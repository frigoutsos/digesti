//
//  WorstOffendersCardViewModel.swift
//
//  ViewModel to handle worst offenders-related calculations.
//
import SwiftUI

@Observable
class WorstOffendersCardViewModel {
    // Returns the food with the highest average value for a numeric symptom
    func worst(_ keyPath: KeyPath<FoodImpact, Double>, from impacts: [FoodImpact]) -> Offender? {
        guard let top = impacts.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] }) else { return nil }

        return Offender(food: top.food, value: top[keyPath: keyPath], isRate: false)
    }

    // Returns the food with the highest bloating rate
    func worstRate(_ keyPath: KeyPath<FoodImpact, Double>, from impacts: [FoodImpact]) -> Offender? {
        guard let top = impacts.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] }),
              top[keyPath: keyPath] > 0 else { return nil }

        return Offender(food: top.food, value: top[keyPath: keyPath], isRate: true)
    }

    func impacts(episodes: [Episode], meals: [Meal])  -> [FoodImpact] {
        computeFoodImpacts(episodes: episodes, meals: meals)
    }
}

// A single worst-offender result for one symptom
struct Offender {
    let food: Food
    let value: Double // The average score for this symptom
    let isRate: Bool // true if value is a 0–1 rate (bloating), false if 1–10
}
