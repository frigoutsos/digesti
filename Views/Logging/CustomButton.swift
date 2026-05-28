//
//  CustomButton.swift
//
//  This struct creates a button to display a string.
//
import SwiftUI

struct CustomButton: View {
    // What text this button should display
    let text: String
    
    // Is the button selected
    var isSelected: Bool
    
    // Do nothing on click
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? .black : .primary)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.accentColor : Color.accentColor.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        // Remove default button background
        .buttonStyle(PlainButtonStyle())
    }
}
