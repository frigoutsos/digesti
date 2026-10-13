////
////  MealLoggingWatchViewModel.swift
////
////  ViewModel to handle computations in the meal logging view for the watch companion app.
////
//import SwiftUI
//
//@Observable
//class MealLoggingWatchViewModel {
//    // Load the foods from JSON once and keep them in memory
//    var allFoods: [Food] = getFoods()
//    
//    // Track the user's input step as they build the meal
//    var input = MealInput()
//    
//    // State to track if we saved a user's meal yet
//    var didSave = false
//    
//    // Computed property to build the meal on-the-fly
//    var builtMeal: Meal {
//        Meal(
//            // We do not ask the user for the date, as we do not allow for logging past meals.
//            date: Date(),
//            foods: input.foods
//        )
//    }
//    
//    // Check if a food is selected
//    func isSelected(food: Food) -> Bool {
//        input.foods.contains { $0.id == food.id}
//    }
//    
//    // Function to save a meal when the user is done selecting foods
//    func saveMeal() throws {
//        guard !didSave else { return }
//        
//        // Create data transfer object to send to iPhone
//        let dto = MealInput(date: Date(), foods: input.foods)
//        
//        do {
//            let data = try JSONEncoder().encode(dto)
//            WatchMessageManager.shared.sendMealData(data) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success():
//                        self.didSave = true
//                    case .failure(let error):
//                        // fallback: mark queued and dismiss or surface error
//                        print("send error:", error)
//                    }
//                }
//            }
//        } catch {
//            print("encode error:", error)
//        }
//    }
//}
