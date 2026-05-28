//
//  CategoryView.swift
//
//  This view displays all the foods with a given category.
//
import SwiftUI

struct CategoryView: View {
    // Take in a category to view
    let category: String
    
    // Take in the list of all foods (do not re-compute here)
    let allFoods: [Food]
    
    var body: some View {
        List {
            Section(header: Text("\(filteredFoods.count) items")
                .font(.subheadline)
                .foregroundStyle(.secondary)) {
                    
                ForEach(filteredFoods) { food in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "fork.knife")
                                    .foregroundStyle(.secondary)
                            )
                        
                        Text(food.name)
                            .font(.body)
                        
                        Spacer()
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var filteredFoods: [Food] {
        return allFoods.filter { food in
            food.category.contains(category)
        }
    }
}
