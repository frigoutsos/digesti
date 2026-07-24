//
//  InputRow.swift
//
//  Describes a row used in the input of an episode.
//
import SwiftUI

struct InputRow<Content: View>: View {
    let rowIcon: String
    let rowTitle: String
    let episodeType: EpisodeType
    let thisStep: LoggingStep
    
    @Binding var currentStep: LoggingStep?
        
    // Compute expansion state based on steps
    var isExpanded: Bool { currentStep == thisStep }
    
    // Take in content for display inside the row
    @ViewBuilder let rowContent: Content
    
    private var isCompleted: Bool {
        guard let currentStep,
              let thisIndex = episodeType.loggingSteps.firstIndex(of: thisStep),
              let currentIndex = episodeType.loggingSteps.firstIndex(of: currentStep)
        else { return false }
        
        return thisIndex < currentIndex
    }
    
    var next: LoggingStep? { currentStep.flatMap { episodeType.next(from: $0) } }
    var prev: LoggingStep? { currentStep.flatMap { episodeType.prev(from: $0) } }
    
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
                            withAnimation(.interpolatingSpring(stiffness: 200, damping: 25)) {
                                    currentStep = prev
                                }
                        }
                        .tint(.primary)
                        .buttonStyle(.bordered)
                        .disabled(prev == nil)
                        
                        Spacer()
                        
                        // Allow continuing
                        Button("Next") {
                            withAnimation(.interpolatingSpring(stiffness: 200, damping: 25)) {
                                    currentStep = next
                                }
                        }
                        .tint(.primary)
                        .buttonStyle(.bordered)
                        .disabled(next == nil)
                    }
                    .padding()
                }
                .padding()
                .background(.accent.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .transition(
                    .asymmetric(
                        insertion: .scale(scale: 0.98, anchor: .top).combined(with: .opacity),
                        removal: .scale(scale: 0.05, anchor: .top).combined(with: .opacity)
                    )
                )
            }
        }
        .padding(.horizontal)
    }
}
