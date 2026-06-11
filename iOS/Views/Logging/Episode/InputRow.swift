//
//  InputRow.swift
//
//  Describes a row used in the input of an episode.
//
import SwiftUI

struct InputRow<Content: View>: View {
    let rowIcon: String
    let rowTitle: String
    let thisStep: LoggingStep
    
    // Binding of the logging view's current input step
    @Binding var inputStep: LoggingStep
    
    // Compute expansion state based on steps
    var isExpanded: Bool { inputStep == thisStep }
    
    // Take in content for display inside the row
    @ViewBuilder let rowContent: Content
    
    private var isCompleted: Bool { thisStep.rawValue < inputStep.rawValue }
    
    var body: some View {
        VStack {
            HStack {
                Label(rowTitle, systemImage: isCompleted ? "checkmark.circle.fill" : rowIcon)
                    .font(.headline)
                
                Spacer ()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .frame(width: 16, alignment: .center)
            }
            .padding()
            .foregroundStyle(isCompleted ? .accent : .primary)

            if (isExpanded) {
                VStack {
                    rowContent
                    
                    HStack {
                        Button("Back") {
                            withAnimation(.spring(duration: 0.35)) {
                                if let prev = inputStep.prev {
                                    inputStep = prev
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.35)) {
                                inputStep = thisStep
                            }
                        }
                        .tint(.primary)
                        .buttonStyle(.bordered)
                        .disabled(inputStep.prev == nil)
                        
                        // Allow continuing
                        Button("Next") {
                            withAnimation(.spring(duration: 0.35)) {
                                if let next = inputStep.next {
                                    inputStep = next
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.35)) {
                                inputStep = thisStep
                            }
                        }
                        .tint(.primary)
                        .buttonStyle(.bordered)
                        .disabled(inputStep.next == nil)
                    }
                }
                .padding()
                .background(.accent.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .transition(
                    .opacity.combined(with: .scale(scale: 0.98, anchor: .top))
                )
            }
        }
        .padding(.horizontal)
    }
}
