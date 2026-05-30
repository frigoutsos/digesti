//
//  NumericStep.swift
//
//  Reusable input view for any episode component that takes in a number.
//
import SwiftUI

struct NumericView: View {
    // Track the current value of the slider
    @Binding var value: Double
    
    // Take in a reusable label to tell the user what they are logging
    let label: String

    // use a local binding with bounds to attach to digital crown
    @State private var crownValue: Double = 5
    
    // State to store focus on the slider
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text(label)
                .font(.headline)
                .foregroundStyle(.primary)

            Text("\(Int(value)) / 10")
                .font(.title2)
                .fontWeight(.semibold)
            
            Slider(value: Binding(get: { value }, set: { newValue in value = min(max(newValue, 1), 10) }), in: 1...10, step: 1) .labelsHidden()
        }
        .focusable(true)
        .focused($isFocused)
        .digitalCrownRotation($crownValue,
            from: 1, through: 10, by: 1,
            sensitivity: .medium,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onAppear {
            crownValue = value
            isFocused = true
        }
        .onChange(of: crownValue) { _, newValue in
            value = newValue
        }
        .onChange(of: value) { _, newValue in
            crownValue = newValue
        }
    }
}
