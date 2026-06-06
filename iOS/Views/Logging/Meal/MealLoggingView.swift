//
//  MealLoggingView.swift
//
//  Contains the logic for selecting foods in the input page.
//
import SwiftUI
import SwiftData

struct MealLoggingView: View {
    // Access the configured model context
    @Environment(\.modelContext) private var modelContext
    
    // Allow the user to click cancel and dismiss the logging flow
    @Environment(\.dismiss) private var dismiss
    
    // State to keep track of our ViewModel object
    @State private var viewModel = MealLoggingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Title/Header
                HStack {
                    Image(systemName: "fork.knife")
                        .foregroundStyle(.accent)
                    
                    Text("What was in your most recent meal?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                .searchable(text: $viewModel.searchText, prompt: "Search foods…")
                .autocorrectionDisabled()

                // Display all content, or just results if searching
                ScrollView {
                    if viewModel.searchText.isEmpty {
                        VStack(alignment: .leading, spacing: 20) {
                            // Display each food category
                            ForEach(viewModel.categorizedFoods.keys.sorted(), id: \.self) { categoryName in
                                // Category header
                                Text("\(categoryName)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)
                                
                                // Display each food in that category
                                VStack(spacing: 10) {
                                    ForEach(viewModel.categorizedFoods[categoryName] ?? [], id: \.id) { food in
                                        CustomButton(text: food.name, isSelected: viewModel.isSelected(food: food)) {
                                            // Toggle selection logic
                                            if (viewModel.isSelected(food: food)) {
                                                viewModel.input.foods.removeAll(where: { $0.id == food.id })
                                            } else {
                                                viewModel.input.foods.append(food)
                                            }
                                        }
                                        .sensoryFeedback(.selection, trigger: viewModel.input.foods.contains(where: { $0.id == food.id }))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 20) {
                            if viewModel.results.isEmpty {
                                ContentUnavailableView(
                                    "No Foods Found",
                                    systemImage: "magnifyingglass",
                                    description: Text("No foods matching \(viewModel.searchText) found.")
                                )                                
                                .listRowBackground(Color.clear)
                                .foregroundStyle(.secondary)
                            } else {
                                Text("Search results for \(viewModel.searchText): ")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                VStack(spacing: 10) {
                                    ForEach(viewModel.results) { food in
                                        CustomButton(text: food.name, isSelected: viewModel.isSelected(food: food)) {
                                            // Toggle selection logic
                                            if (viewModel.isSelected(food: food)) {
                                                viewModel.input.foods.removeAll(where: { $0.id == food.id })
                                            } else {
                                                viewModel.input.foods.append(food)
                                            }
                                        }
                                        .sensoryFeedback(.selection, trigger: viewModel.input.foods.contains(where: { $0.id == food.id }))
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
                        do {
                            try viewModel.saveMeal(modelContext: modelContext)
                            dismiss()
                        } catch {
                            print("Failed to save episode: ", error)
                        }
                    }
                    // Provide user with a success haptic upon saving the episode
                    .sensoryFeedback(.success, trigger: viewModel.didSave)
                }
            }
        }
    }
}
