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
                VStack(alignment: .leading) {
                    // Display each food category
                    ForEach(allFoods.sorted(by: { $0.name < $1.name }), id: \.id) { food in
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
                    .padding(.horizontal)
                }
            }
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
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
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
        let dto = MealDTO(date: Date(), foods: input.foods)
        
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
