//
//  HealthKitService.swift
//
//  Central service for requesting permissions and fetching
//  sleep, HRV, dietary, and activity data from HealthKit.
//
import HealthKitUI
import SwiftUI
import Combine

final class HealthKitService: ObservableObject {
    static let shared = HealthKitService()
    
    private let store = HKHealthStore()

    // Authorization state
    @Published var isAuthorized = false
    @Published var authorizationDenied = false

    // The full set of types we want to read
    private var readTypes: Set<HKObjectType> {
        var types: Set<HKObjectType> = [
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
        ]
        // Dietary types
        let dietaryIdentifiers: [HKQuantityTypeIdentifier] = [
            .dietaryEnergyConsumed,
            .dietaryCarbohydrates,
            .dietaryFiber,
            .dietaryFatTotal,
            .dietaryProtein,
            .dietaryCaffeine,
            .dietarySodium,
            .dietarySugar,
        ]
        dietaryIdentifiers.forEach { types.insert(HKObjectType.quantityType(forIdentifier: $0)!) }
        return types
    }

    // Update authorization on the main actor
    @MainActor
    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        do {
            try await store.requestAuthorization(toShare: [], read: readTypes)
            isAuthorized = true
            authorizationDenied = false
        } catch {
            authorizationDenied = true
            isAuthorized = false
        }
    }

    
    // Sleep
    struct SleepSample {
        let date: Date        // Night of sleep (start of the window)
        let hours: Double     // Total asleep hours
    }

    func fetchSleep(from start: Date, to end: Date) async -> [SleepSample] {
        guard let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)

        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, _ in
                guard let samples = samples as? [HKCategorySample] else {
                    continuation.resume(returning: [])
                    return
                }

                // Group by calendar day, sum asleep minutes
                var byDay: [Date: Double] = [:]
                let cal = Calendar.current
                for s in samples {
                    guard s.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue
                       || s.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue
                       || s.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue
                       || s.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue
                    else { continue }
                    let day = cal.startOfDay(for: s.startDate)
                    byDay[day, default: 0] += s.endDate.timeIntervalSince(s.startDate) / 3600
                }

                let result = byDay.map { SleepSample(date: $0.key, hours: $0.value) }
                    .sorted { $0.date < $1.date }
                continuation.resume(returning: result)
            }
            store.execute(query)
        }
    }

    // HRV
    struct HRVSample {
        let date: Date
        let sdnn: Double   // milliseconds
    }

    func fetchHRV(from start: Date, to end: Date) async -> [HRVSample] {
        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return [] }
        return await fetchDailySamples(type: type, unit: .secondUnit(with: .milli), from: start, to: end)
            .map { HRVSample(date: $0.date, sdnn: $0.value) }
    }

    // Activity
    struct ActivitySample {
        let date: Date
        let activeCalories: Double
        let steps: Double
        let exerciseMinutes: Double
    }

    func fetchActivity(from start: Date, to end: Date) async -> [ActivitySample] {
        async let calories = fetchDailySum(
            identifier: .activeEnergyBurned,
            unit: .kilocalorie(),
            from: start, to: end
        )
        async let steps = fetchDailySum(
            identifier: .stepCount,
            unit: .count(),
            from: start, to: end
        )
        async let exercise = fetchDailySum(
            identifier: .appleExerciseTime,
            unit: .minute(),
            from: start, to: end
        )

        let (cal, stp, ex) = await (calories, steps, exercise)

        // Union all days present in any of the three
        let allDays = Set(cal.keys).union(stp.keys).union(ex.keys)
        return allDays.map { day in
            ActivitySample(
                date: day,
                activeCalories: cal[day] ?? 0,
                steps: stp[day] ?? 0,
                exerciseMinutes: ex[day] ?? 0
            )
        }.sorted { $0.date < $1.date }
    }

    // Dietary
    struct DietarySample {
        let date: Date
        let calories: Double
        let carbs: Double       // grams
        let fiber: Double       // grams
        let fat: Double         // grams
        let protein: Double     // grams
        let caffeine: Double    // grams
        let sodium: Double      // grams
        let sugar: Double       // grams
    }

    func fetchDietary(from start: Date, to end: Date) async -> [DietarySample] {
        async let calories  = fetchDailySum(identifier: .dietaryEnergyConsumed,  unit: .kilocalorie(),              from: start, to: end)
        async let carbs     = fetchDailySum(identifier: .dietaryCarbohydrates,    unit: .gram(),                     from: start, to: end)
        async let fiber     = fetchDailySum(identifier: .dietaryFiber,            unit: .gram(),                     from: start, to: end)
        async let fat       = fetchDailySum(identifier: .dietaryFatTotal,         unit: .gram(),                     from: start, to: end)
        async let protein   = fetchDailySum(identifier: .dietaryProtein,          unit: .gram(),                     from: start, to: end)
        async let caffeine  = fetchDailySum(identifier: .dietaryCaffeine,         unit: .gram(),                     from: start, to: end)
        async let sodium    = fetchDailySum(identifier: .dietarySodium,           unit: .gram(),                     from: start, to: end)
        async let sugar     = fetchDailySum(identifier: .dietarySugar,            unit: .gram(),                     from: start, to: end)

        let (cal, carb, fib, fat_, pro, caf, sod, sug) = await (calories, carbs, fiber, fat, protein, caffeine, sodium, sugar)

        let allDays = Set(cal.keys)
        return allDays.map { day in
            DietarySample(
                date: day,
                calories:  cal[day]  ?? 0,
                carbs:     carb[day] ?? 0,
                fiber:     fib[day]  ?? 0,
                fat:       fat_[day] ?? 0,
                protein:   pro[day]  ?? 0,
                caffeine:  caf[day]  ?? 0,
                sodium:    sod[day]  ?? 0,
                sugar:     sug[day]  ?? 0
            )
        }.sorted { $0.date < $1.date }
    }

    // Private helpers
    private struct DailyValue {
        let date: Date
        let value: Double
    }

    // Daily average for types like HRV where you want mean-per-day
    private func fetchDailySamples(
        type: HKQuantityType,
        unit: HKUnit,
        from start: Date,
        to end: Date
    ) async -> [DailyValue] {
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, _ in
                guard let samples = samples as? [HKQuantitySample] else {
                    continuation.resume(returning: [])
                    return
                }
                var byDay: [Date: [Double]] = [:]
                let cal = Calendar.current
                for s in samples {
                    let day = cal.startOfDay(for: s.startDate)
                    byDay[day, default: []].append(s.quantity.doubleValue(for: unit))
                }
                let result = byDay.map { DailyValue(date: $0.key, value: $0.value.reduce(0,+) / Double($0.value.count)) }
                    .sorted { $0.date < $1.date }
                continuation.resume(returning: result)
            }
            store.execute(query)
        }
    }

    // Daily sum via HKStatisticsCollectionQuery (efficient for quantity types)
    private func fetchDailySum(
        identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        from start: Date,
        to end: Date
    ) async -> [Date: Double] {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return [:] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        let anchorDate = Calendar.current.startOfDay(for: start)
        let interval = DateComponents(day: 1)

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsCollectionQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: anchorDate,
                intervalComponents: interval
            )
            query.initialResultsHandler = { _, results, _ in
                var out: [Date: Double] = [:]
                results?.enumerateStatistics(from: start, to: end) { stats, _ in
                    if let sum = stats.sumQuantity() {
                        out[stats.startDate] = sum.doubleValue(for: unit)
                    }
                }
                continuation.resume(returning: out)
            }
            store.execute(query)
        }
    }
}
