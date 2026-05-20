//
//  FoodSelectionView.swift
//  ibs-app
//
//  Created by Franklin Rigoutsos on 5/2/26.
//
// Contains the logic for selecting foods in the input page.
import SwiftUI

struct FoodSelectionView: View {
    let allFoods: [Food]
    
    @Binding var selectedFoods: [Food]
    
    @State var searchText: String = ""
    
    // Assuming this is part of the FoodDataStore class
    private var allCategories: [String] {
        // Flatten into a long array
        let allCategoryNames = allFoods.flatMap { $0.category }
        
        // Remove duplicates using a set and return as an array
        return Array(Set(allCategoryNames)).sorted()
    }

    
    // Helper to group all foods by category name
    private var categorizedFoods: [String: [Food]] {
        var dictionary: [String: [Food]] = [:]
        let uniqueCategories = allCategories
        
        for categoryName in uniqueCategories {
            // Get the list of food in each category
            let foodsInThisCategory = allFoods.filter { food in
                food.category.contains(categoryName)
            }
            
            // Store the result in the dictionary
            dictionary[categoryName] = foodsInThisCategory
        }
            
        return dictionary
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title/Header
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.accent)
                
                Text("What triggered your episode?")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            // Search Bar
            TextField("Search by food name...", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    // Conditional clear button
                    Group {
                        Button("Clear Search", role: .cancel) {
                            searchText = ""
                        }
                        .opacity(searchText.isEmpty ? 0 : 1)
                    }
                )
            
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
                                    CustomButton(text: food.name, isSelected: selectedFoods.contains(where: { $0.id == food.id})) {
                                        // Toggle selection logic
                                        if selectedFoods.contains(where: { $0.id == food.id }) {
                                            selectedFoods.removeAll(where: { $0.id == food.id })
                                        } else {
                                            selectedFoods.append(food)
                                        }
                                    }
                                    .sensoryFeedback(.selection, trigger: selectedFoods.contains(where: { $0.id == food.id }))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Text("Search Results for \"\(searchText)\":").font(.subheadline).foregroundStyle(.secondary)
                        
                        // Filter and display results
                        let results = allFoods.filter { food in
                            food.name.localizedCaseInsensitiveContains(searchText)
                        }
                        
                        if results.isEmpty {
                            Text("No foods found matching '\(searchText)'").foregroundStyle(.secondary)
                        } else {
                            ForEach(results) { food in
                                CustomButton(text: food.name, isSelected: selectedFoods.contains(where: { $0.id == food.id })) {
                                    // Toggle selection logic
                                    if selectedFoods.contains(where: { $0.id == food.id }) {
                                        selectedFoods.removeAll(where: { $0.id == food.id })
                                    } else {
                                        selectedFoods.append(food)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}
