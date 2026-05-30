//
//  MealLoggingWatchView.swift
//
//  Contains the logic for selecting foods in the input page for the watch app.
//
import SwiftUI
import WatchConnectivity

struct MealLoggingWatchView: View {
    // Allow the user to click cancel and dismiss the logging flow
    @Environment(\.dismiss) private var dismiss
    
    // State to load the foods from JSON once and keep them in memory
    @State private var allFoods: [Food] = getFoods()
    
    // State of the user's input as they go through the screen
    @State private var input = MealInput()
    
    // State to track if we saved a user's meal yet
    @State private var didSave = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // Display each food category
                ForEach(allFoods.sorted(by: { $0.name < $1.name }), id: \.id) { food in
                    
                    let isSelected = input.foods.contains { $0.id == food.id}
                    
                    CustomButton(text: food.name, isSelected: isSelected) {
                        // Toggle selection logic
                        if (isSelected) {
                            input.foods.removeAll(where: { $0.id == food.id })
                        } else {
                            input.foods.append(food)
                        }
                    }
                }
                // UUID() should be able to trigger feedback
                .padding()
                .sensoryFeedback(.selection, trigger: UUID())
                .navigationTitle("Foods")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    
                    // Confirm (checkmark)
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            saveMeal()
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        // Provide user with a success haptic upon saving the episode
                        .sensoryFeedback(.success, trigger: didSave)
                    }
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
        guard !didSave else { return }
        
        // Create data transfer object to send to iPhone
        let dto = MealInput(date: Date(), foods: input.foods)
        
        do {
            let data = try JSONEncoder().encode(dto)
            WatchMessageManager.shared.sendMealData(data) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        didSave = true
                        dismiss()
                    case .failure(let error):
                        // fallback: mark queued and dismiss or surface error
                        print("send error:", error)
                    }
                }
            }
        } catch {
            print("encode error:", error)
        }
    }
}
