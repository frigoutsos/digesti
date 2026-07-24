//
//  ActionButton.swift
//
//  Reusable button view to represent an action.
//
import SwiftUI

struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Label(title, systemImage: icon)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .tint(.accent)
        .padding(.horizontal, 48)
    }
}
