//
//  NumericStep.swift
//
//  Reusable input view for any episode component that takes in a number.
//
import SwiftUI

struct NumericView: View {
    // Track the current value of the slider
    @Binding var value: Int
    
    // Take in a reusable label to tell the user what they are logging
    let label: String

    // State to store focus on the slider
    @FocusState private var isFocused: Bool
    
    private var doubleValue: Binding<Double> {
        Binding(
            get: { Double(value) },
            set: { value = Int($0.rounded()) }
        )
    }
    
    let maxValue: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text(label)
                .font(.headline)
                .foregroundStyle(.primary)

            Text("\(Int(value)) / \(maxValue)")
                .font(.title2)
                .fontWeight(.semibold)
            
            Slider(value: doubleValue, in: 1...Double(maxValue), step: 1)
                .labelsHidden()
        }
        .focusable(true)
        .focused($isFocused)
        .digitalCrownRotation(doubleValue,
            from: 1, through: Double(maxValue), by: 1,
            sensitivity: .medium,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onAppear {
            isFocused = true
        }
    }
}
