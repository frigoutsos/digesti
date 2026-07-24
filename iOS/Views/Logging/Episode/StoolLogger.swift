//
//  StoolLogger.swift
//
//  View to log stool episodes.
//
import SwiftUI
import SwiftData

struct StoolLogger: View {
    // Access the configured model context
    @Environment(\.modelContext) private var modelContext

    @Binding var viewModel: EpisodeLoggingViewModel
    
    // Allow the user to click cancel and dismiss the logging flow
    @Environment(\.dismiss) private var dismiss
    
    // Compute all the steps we have to go through when logging bloating
    var steps: [LoggingStep] { EpisodeType.stool.loggingSteps }

    var body: some View {
        VStack {
            if (viewModel.step != .summary) {
                InputRow(rowIcon: "clock",
                         rowTitle: "Last Bowel Movement",
                         episodeType: .stool,
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
                
                InputRow(rowIcon: "exclamationmark.circle",
                         rowTitle: "Stool Urgency",
                         episodeType: .stool,
                         thisStep: .urgency,
                         currentStep: $viewModel.step) { // Changed to bind currentStep if needed, based on previous context
                    EmojiRow(bindingValue: $viewModel.input.stoolUrgency)
                }
                
                if (viewModel.step != .urgency) { Divider() }
                
                InputRow(rowIcon: "figure.run",
                         rowTitle: "Stool Effort",
                         episodeType: .stool,
                         thisStep: .effort,
                         currentStep: $viewModel.step) { // Changed to bind currentStep if needed
                    EmojiRow(bindingValue: $viewModel.input.stoolEffort)
                }
                
                if (viewModel.step != .effort) { Divider() }
                
                InputRow(rowIcon: "toilet.fill",
                         rowTitle: "Bristol Stool Type",
                         episodeType: .stool,
                         thisStep: .stoolType,
                         currentStep: $viewModel.step) { // Changed to bind currentStep if needed
                    HStack {
                        Slider(value: Binding(get: { Double(viewModel.input.stoolConsistency) },
                                              set: { viewModel.input.stoolConsistency = Int($0.rounded()) } ),
                               in: 1...7, step: 1)
                            .tint(.secondary)
                        
                        Spacer()
                        
                        Text("\(viewModel.input.stoolConsistency) / 7")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Button {
                            viewModel.presentStoolSheet = true
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .foregroundStyle(.accent)
                        .sheet(isPresented: $viewModel.presentStoolSheet) {
                            NavigationStack {
                                VStack {
                                    BristolScaleListView()
                                        .navigationBarTitleDisplayMode(.inline)
                                        .toolbar {
                                            ToolbarItem(placement: .topBarTrailing) {
                                                Button {
                                                    viewModel.presentStoolSheet = false
                                                } label: {
                                                    Image(systemName: "xmark")
                                                }
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
                
                if (viewModel.step != .stoolType) { Divider() }
                
                InputRow(rowIcon: "figure.mind.and.body",
                         rowTitle: "Stress",
                         episodeType: .stool,
                         thisStep: .stress,
                         currentStep: $viewModel.step) { // Changed to bind currentStep if needed
                    EmojiRow(bindingValue: $viewModel.input.stress)
                }
            } else {
                VStack {
                    EpisodeView(episodeToView: viewModel.input)
                    
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
