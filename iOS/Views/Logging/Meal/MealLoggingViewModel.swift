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

    // Get all categories of the foods in our list
    func allCategories() -> [String] {
        // Flatten into a long array
        let allCategoryNames = allFoods.flatMap { $0.category }
        
        // Remove duplicates using a set and return as an array
        return Array(Set(allCategoryNames)).sorted()
    }

    // Helper to group all foods by category name
    var categorizedFoods: [String: [Food]] {
        var dictionary: [String: [Food]] = [:]
        
        for categoryName in allCategories() {
            // Get the list of food in each category
            let foodsInThisCategory = allFoods.filter { food in
                food.category.contains(categoryName)
            }
            
            // Store the result in the dictionary
            dictionary[categoryName] = foodsInThisCategory
        }
            
        return dictionary
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
            let fields = [food.name] + food.searchMatches + food.category

            let bestScore = fields.map { field in
                score(searchText, field)
            }.max() ?? 0

            return (food, bestScore)
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
