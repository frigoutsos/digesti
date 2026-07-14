//
//  EmojiButton.swift
//
//  Created by Franklin Rigoutsos on 6/9/26.
//
import SwiftUI

struct EmojiButton: View {
    let emojiToView: String
    let colorValue: Color
    let numberValue: Int
    
    // Take in a binding to set the value
    @Binding var value: Int
    
    // Check if we have one selected
    private var isSelected: Bool { value == numberValue }
    
    var body: some View {
        VStack {
            Button {
                withAnimation(.smooth(duration: 0.2)) {
                    value = numberValue
                }
            } label: {
                Text(emojiToView)
                    .font(.title)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(isSelected ? colorValue : .secondary)
                    )
            }
            
        }
    }
}
