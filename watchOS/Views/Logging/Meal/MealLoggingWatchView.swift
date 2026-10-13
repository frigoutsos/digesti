////
////  MealLoggingWatchView.swift
////
////  Contains the logic for selecting foods in the input page for the watch app.
////
//import SwiftUI
//import WatchConnectivity
//
//struct MealLoggingWatchView: View {
//    // Allow the user to click cancel and dismiss the logging flow
//    @Environment(\.dismiss) private var dismiss
//    
//    // State to keep track of our ViewModel object
//    @State private var viewModel = MealLoggingWatchViewModel()
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                // Display each food category
//                ForEach(viewModel.allFoods.sorted(by: { $0.name < $1.name }), id: \.id) { food in
//                    CustomButton(text: food.name, isSelected: viewModel.isSelected(food: food)) {
//                        // Toggle selection logic
//                        if (viewModel.isSelected(food: food)) {
//                            viewModel.input.foods.removeAll(where: { $0.id == food.id })
//                        } else {
//                            viewModel.input.foods.append(food)
//                        }
//                    }
//                }
//                // UUID() should be able to trigger feedback
//                .padding()
//                .sensoryFeedback(.selection, trigger: UUID())
//                .navigationTitle("Foods")
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .cancellationAction) {
//                        Button {
//                            dismiss()
//                        } label: {
//                            Image(systemName: "xmark")
//                        }
//                    }
//                    ToolbarItem(placement: .confirmationAction) {
//                        Button {
//                            do {
//                                try viewModel.saveMeal()
//                                dismiss()
//                            } catch {
//                                print("Failed to save episode: ", error)
//                            }
//                        } label: {
//                            Image(systemName: "checkmark")
//                        }
//                        // Provide user with a success haptic upon saving the episode
//                        .sensoryFeedback(.success, trigger: viewModel.didSave)
//                    }
//                }
//            }
//        }
//    }
//}
