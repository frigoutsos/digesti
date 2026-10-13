//
//  MealLoggingViewModel.swift
//
//  ViewModel to handle calculations related to meal logging.
//
import SwiftUI
import SwiftData

@Observable
class MealLoggingViewModel {
    // Load the foods from JSON once and keep them in memory
    var allFoods: [Food] = getFoods()
    
    // Keep track of the user's input as they input foods
    var input = MealInput()
    
    // Hold user's current search query
    var searchText: String = ""

    // Track if we saved the meal yet
    var didSave = false

    // Present the uncategorized dataset in a predictable order.
    var sortedFoods: [Food] {
        allFoods.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }
    
    // Computed property to build the meal on-the-fly
    var builtMeal: Meal {
        Meal(
            // We do not ask the user for the date, as we do not allow for logging past meals.
            date: Date(),
            foods: input.foods
        )
    }
    
    // Scored search for foods
    var results: [Food] {
        allFoods.map { food in
            (food, score(searchText, food.description))
        }
        .filter { $0.1 > 0 }
        .sorted { $0.1 > $1.1 }
        .map { $0.0 }
    }
    
    // Check if a food is selected
    func isSelected(food: Food) -> Bool {
        input.foods.contains { $0.id == food.id}
    }
    
    // Function to save a meal when the user is done selecting foods
    func saveMeal(modelContext: ModelContext) throws {
        guard !didSave else { return }
        
        modelContext.insert(builtMeal)
        try modelContext.save()
        didSave = true
    }
}
