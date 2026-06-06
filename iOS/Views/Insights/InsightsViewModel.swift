//
//  InsightsViewModel.swift
//
//  ViewModel to handle insights-related calculations.
//
import SwiftUI

@Observable
class InsightsViewModel {
    
    let healthKit = HealthKitService.shared

    func onAppear() async {
        await healthKit.requestAuthorization()
    }
    
    // Which time window the user has selected
    var selectedRange: InsightsRange = .thirtyDays
    
    // Episodes that fall within the selected time window
    func episodesInRange(from episodes: [Episode]) -> [Episode] {
        guard let cutoff = selectedRange.cutoff else { return episodes }
        return episodes.filter { $0.onset >= cutoff }
    }

    // Episodes in the previous equal window, used for trend arrows
    func episodesInPreviousRange(from episodes: [Episode]) -> [Episode] {
        guard let cutoff = selectedRange.cutoff,
              let prevCutoff = selectedRange.previousCutoff else { return [] }
        return episodes.filter { $0.onset >= prevCutoff && $0.onset < cutoff }
    }

    // Meals that fall within the selected time window
    func mealsInRange(from meals: [Meal]) -> [Meal] {
        guard let cutoff = selectedRange.cutoff else { return meals }
        return meals.filter { $0.date >= cutoff }
    }
}

// Time range options for the insights page
enum InsightsRange: String, CaseIterable, Identifiable {
    case thirtyDays = "30d"
    case ninetyDays = "90d"
    case allTime = "All Time"

    var id: Self { self }

    // How far back to look, nil means no limit (all time)
    var cutoff: Date? {
        switch self {
        case .thirtyDays: return Calendar.current.date(byAdding: .day, value: -30, to: Date())
        case .ninetyDays: return Calendar.current.date(byAdding: .day, value: -90, to: Date())
        case .allTime: return nil
        }
    }

    // The equivalent window before the current one, used for trend comparisons
    var previousCutoff: Date? {
        switch self {
        case .thirtyDays: return Calendar.current.date(byAdding: .day, value: -60, to: Date())
        case .ninetyDays: return Calendar.current.date(byAdding: .day, value: -180, to: Date())
        case .allTime: return nil
        }
    }
}
