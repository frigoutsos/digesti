//
//  ConstipationLogger.swift
//
//  View to log constipation episodes.
//
import SwiftUI
import SwiftData

struct ConstipationLogger: View {
    // Access the configured model context
    @Environment(\.modelContext) private var modelContext

    @Binding var viewModel: EpisodeLoggingViewModel

    // Allow the user to click cancel and dismiss the logging flow
    @Environment(\.dismiss) private var dismiss
    
    // Compute all the steps we have to go through when logging bloating
    var steps: [LoggingStep] { EpisodeType.constipation.loggingSteps }

    var body: some View {
        VStack {
            if (viewModel.step != .summary) {
                InputRow(rowIcon: "clock",
                         rowTitle: "Last Bowel Movement",
                         episodeType: .constipation,
                         thisStep: .onset,
                         currentStep: $viewModel.step) {
                    DatePicker("Movement",
                               selection: $viewModel.input.onset,
                               in: ...Date(),
                               displayedComponents: [.date, .hourAndMinute])
                    .font(.subheadline)
                    .tint(.accent)
                    .datePickerStyle(.graphical)
                }
                
                if (viewModel.step != .onset) { Divider() }
                  
                InputRow(rowIcon: "figure.run",
                         rowTitle: "Stool Effort",
                         episodeType: .constipation,
                         thisStep: .effort,
                         currentStep: $viewModel.step) {
                    EmojiRow(bindingValue: $viewModel.input.stoolEffort)
                }
                
                if (viewModel.step != .effort) { Divider() }

                InputRow(rowIcon: "figure.mind.and.body",
                         rowTitle: "Stress",
                         episodeType: .constipation,
                         thisStep: .stress,
                         currentStep: $viewModel.step) {
                    EmojiRow(bindingValue: $viewModel.input.stress)
                }
            } else {
                VStack {
                    EpisodeView(episode: viewModel.input)
                    
                    Button("Back") {
                        withAnimation(.spring(duration: 0.35)) {
                            // We subtract 2 because the last is the summary
                            viewModel.step = steps[steps.count - 2]
                        }
                    }
                    .tint(.accent)
                    .buttonStyle(.bordered)
                }
            }
        }
        .onAppear {
            if viewModel.step == nil {
                viewModel.step = steps.first
            }
        }
    }
}
