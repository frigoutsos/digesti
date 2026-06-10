//
//  EmojiRow.swift
//
//  Present the user with a row of emojis for logging a specific symptom.
//
import SwiftUI

struct EmojiRow: View {
    // Take in a value to bind the selection to
    @Binding var bindingValue: Int
        
    var body: some View {
        HStack {
            // We do index-based iteration to allow for conditional Spacer()s
            let cases = EmojiType.allCases
            
            ForEach(cases.indices, id: \.self) { index in
                EmojiButton(emojiToView: cases[index].rawValue,
                            colorValue: getColor(for: cases[index].id),
                            numberValue: cases[index].id,
                            value: $bindingValue)
                
                if index < cases.count - 1 {
                    Spacer()
                }
            }
        }
    }
}

enum EmojiType: String, Identifiable, CaseIterable {
    case one = "🙂"
    case two = "😐"
    case three = "😞"
    case four = "😣"
    case five = "😵"
    
    var id: Int {
        switch self {
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        }
    }
}
