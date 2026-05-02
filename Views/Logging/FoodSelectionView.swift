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
    
    // Helper to group all foods by category name
    var categorizedFoods: [String: [Food]] {
        Dictionary(grouping: allFoods, by: { $0.category })
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
            
            // 3. Content Display: Conditional logic for Search vs. Browse
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
                                ForEach(categorizedFoods[categoryName] ?? [], id: \.self) { food in
                                    FoodButton(food: food, isSelected: selectedFoods.contains(food)) {
                                        // Toggle selection logic
                                        if selectedFoods.contains(food) {
                                            selectedFoods.removeAll { $0 == food }
                                        } else {
                                            selectedFoods.append(food)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 10)
                    }
                } else {
                    VStack(spacing: 10) {
                        Text("Search Results for \"\(searchText)\":").font(.subheadline).foregroundStyle(.secondary)
                        
                        // Filter and display results
                        let results = allFoods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                        
                        if results.isEmpty {
                            Text("No foods found matching '\(searchText)'").foregroundStyle(.secondary)
                        } else {
                            ForEach(results) { food in
                                FoodButton(food: food, isSelected: selectedFoods.contains(food)) {
                                    // Toggle selection logic
                                    if selectedFoods.contains(food) {
                                        selectedFoods.removeAll { $0 == food }
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
