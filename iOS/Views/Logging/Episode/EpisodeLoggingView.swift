//
//  LoggingView.swift
//
//  This view guides the user through logging episodes.
//
import SwiftUI
import SwiftData

struct EpisodeLoggingView: View {
    // Access the configured model context
    @Environment(\.modelContext) private var modelContext
    
    // Allow the user to click cancel and dismiss the logging flow
    @Environment(\.dismiss) private var dismiss
    
    // State to keep track of our ViewModel object
    @State private var viewModel = EpisodeLoggingViewModel()
    
    var body: some View {
        // Change the view programatically as the user clicks through the prompts
        NavigationStack {
            ScrollView {
                if (viewModel.step != .summary) {
                    InputRow(rowIcon: "calendar",
                             rowTitle: "Symptom Onset",
                             thisStep: .onset,
                             inputStep: $viewModel.step) {
                        DatePicker("Onset",
                                   selection: $viewModel.input.onset,
                                   in: ...Date(),
                                   displayedComponents: [.date, .hourAndMinute])
                        .font(.subheadline)
                        .tint(.accent)
                        .datePickerStyle(.graphical)
                    }
                    
                    if (viewModel.step != .onset) { Divider() }
                    
                    InputRow(rowIcon: "clock",
                             rowTitle: "Last Bowel Movement",
                             thisStep: .movement,
                             inputStep: $viewModel.step) {
                        DatePicker("Movement",
                                   selection: $viewModel.input.movement,
                                   in: ...Date(),
                                   displayedComponents: [.date, .hourAndMinute])
                        .font(.subheadline)
                        .tint(.accent)
                        .datePickerStyle(.graphical)
                    }
                    
                    if (viewModel.step != .movement) { Divider() }
                    
                    InputRow(rowIcon: "speedometer",
                             rowTitle: "Intensity",
                             thisStep: .intensity,
                             inputStep: $viewModel.step) {
                        EmojiRow(bindingValue: $viewModel.input.intensity)
                    }
                    
                    if (viewModel.step != .intensity) { Divider() }
                    
                    InputRow(rowIcon: "figure.mind.and.body",
                             rowTitle: "Stress",
                             thisStep: .stress,
                             inputStep: $viewModel.step) {
                        EmojiRow(bindingValue: $viewModel.input.stress)
                    }
                    
                    if (viewModel.step != .stress) { Divider() }
                    
                    InputRow(rowIcon: "balloon.fill",
                             rowTitle: "Bloating",
                             thisStep: .bloating,
                             inputStep: $viewModel.step) {
                        HStack(spacing: 12) {
                            Button {
                                viewModel.input.bloating = true
                                viewModel.hasSelectedBloating = true
                            } label: {
                                Text("Yes")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(viewModel.hasSelectedBloating == true ? .red : .secondary)
                            .padding(.horizontal)
                            
                            Button {
                                viewModel.input.bloating = false
                                viewModel.hasSelectedBloating = false
                            } label: {
                                Text("No")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(viewModel.hasSelectedBloating == false ? .green : .secondary)
                            .padding(.horizontal)
                        }
                    }
                    
                    if (viewModel.step != .bloating) { Divider() }
                    
                    InputRow(rowIcon: "toilet.fill",
                             rowTitle: "Bristol Stool Type",
                             thisStep: .stoolType,
                             inputStep: $viewModel.step) {
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
                    
                    InputRow(rowIcon: "exclamationmark.circle",
                             rowTitle: "Stool Urgency",
                             thisStep: .urgency,
                             inputStep: $viewModel.step) {
                        EmojiRow(bindingValue: $viewModel.input.stoolUrgency)
                    }
                    
                    if (viewModel.step != .urgency) { Divider() }
                    
                    InputRow(rowIcon: "figure.run",
                             rowTitle: "Stool Effort",
                             thisStep: .effort,
                             inputStep: $viewModel.step) {
                        EmojiRow(bindingValue: $viewModel.input.stoolEffort)
                    }
                    
                } else {
                    VStack {
                        EpisodeView(episodeToView: viewModel.builtEpisode)
                        
                        Button("Back") {
                            withAnimation(.spring(duration: 0.35)) {
                                viewModel.step = .summary.prev!
                            }
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.35)) {
                                viewModel.step = .summary.prev!
                            }
                        }
                        .tint(.accent)
                        .buttonStyle(.bordered)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        do {
                            try viewModel.saveEpisode(modelContext: modelContext)
                            dismiss()
                        } catch {
                            print("Failed to save episode: ", error)
                        }
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    // Provide user with a success haptic upon saving the episode
                    .sensoryFeedback(.success, trigger: viewModel.didSave)
                }
            }
        }
    }
}

#Preview {
    EpisodeLoggingView()
}
