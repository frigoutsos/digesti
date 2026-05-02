//
//  FoodButton.swift
//  ibs-app
//
//  This struct creates a button for a food object.
//
import SwiftUI

struct FoodButton: View {
    // What food is this button for
    let food: Food
    
    // Is the button selected
    var isSelected: Bool
    
    // Do nothing on click
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(food.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? .black : .primary)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.accentColor : Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        // Prevents the button from applying default SwiftUI background colors when selected
        .buttonStyle(PlainButtonStyle())
    }
}
