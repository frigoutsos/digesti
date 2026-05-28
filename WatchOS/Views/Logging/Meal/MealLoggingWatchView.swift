//
//  MealLoggingWatchView.swift
//
//  Contains the logic for selecting foods in the input page for the watch app.
//
import SwiftUI

struct MealLoggingWatchView: View {
    // Allow the user to click cancel and dismiss the logging flow
    @Environment(\.dismiss) private var dismiss
    
    // State to load the foods from JSON once and keep them in memory
    @State private var allFoods: [Food] = getFoods()
    
    // State of the user's input as they go through the screen
    @State private var input = MealInput()
    
    // State to track if we saved a user's meal yet
    @State private var didSave = false
    
    // Computed property to alphabetize foods
    private var alphabetizedFoods: [Food] {
        allFoods.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Display all content, or just results if searching
                ScrollView {
                    if searchText.isEmpty {
                        VStack(alignment: .leading, spacing: 20) {
                            // Display each food category
                            ForEach(categorizedFoods.keys.sorted(), id: \.self) { categoryName in
                                // Category header
                                Text("\(categoryName)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)
                                
                                // Display each food in that category
                                VStack(spacing: 10) {
                                    ForEach(categorizedFoods[categoryName] ?? [], id: \.id) { food in
                                        CustomButton(text: food.name, isSelected: input.foods.contains(where: { $0.id == food.id})) {
                                            // Toggle selection logic
                                            if input.foods.contains(where: { $0.id == food.id }) {
                                                input.foods.removeAll(where: { $0.id == food.id })
                                            } else {
                                                input.foods.append(food)
                                            }
                                        }
                                        .sensoryFeedback(.selection, trigger: input.foods.contains(where: { $0.id == food.id }))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Search Results for \"\(searchText)\":").font(.subheadline).foregroundStyle(.secondary)

                            // Scored search for foods
                            let results = allFoods.map { food in
                                    let fields = [food.name] + food.searchMatches + food.category
                                    
                                    let bestScore = fields.map { field in
                                        score(searchText, field)
                                    }.max() ?? 0
                                    
                                    return (food, bestScore)
                                }
                                .filter { $0.1 > 0 }
                                .sorted { $0.1 > $1.1 }
                                .map { $0.0 }
                            
                            if results.isEmpty {
                                Text("No foods found matching '\(searchText)'").foregroundStyle(.secondary)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(results) { food in
                                        CustomButton(text: food.name, isSelected: input.foods.contains(where: { $0.id == food.id })) {
                                            // Toggle selection logic
                                            if input.foods.contains(where: { $0.id == food.id }) {
                                                input.foods.removeAll(where: { $0.id == food.id })
                                            } else {
                                                input.foods.append(food)
                                            }
                                        }
                                        .sensoryFeedback(.selection, trigger: input.foods.contains(where: { $0.id == food.id }))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("Foods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        saveMeal()
                    }
                    // Provide user with a success haptic upon saving the episode
                    .sensoryFeedback(.success, trigger: didSave)
                }
            }
        }
    }
    
    // Computed property to build the meal on-the-fly
    private var builtMeal: Meal {
        Meal(
            // We do not ask the user for the date, as we do not allow for logging past meals.
            date: Date(),
            foods: input.foods
        )
    }
    
    // Function to save a meal when the user is done selecting foods
    private func saveMeal() {
        if (!didSave) {
            context.insert(builtMeal)
            
            do {
                try context.save()
                didSave = true
                dismiss()
            } catch {
                print("Error saving meal:", error)
            }
        }
    }
}
