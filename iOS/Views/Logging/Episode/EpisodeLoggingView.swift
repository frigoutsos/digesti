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
            VStack(alignment: .leading, spacing: 24) {
                // Programmatically change the content displayed based on the user's step
                stepContent
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
        }
    }
    
    // Change the content to display above based on the user's step
    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.step {
        case 1:
            // Pass in the current View's input state
            BackgroundView(
                onset: $viewModel.input.onset,
                movement: $viewModel.input.movement,
                intensity: $viewModel.input.intensity,
                stress: $viewModel.input.stress,
                bloating: $viewModel.input.bloating
            )
        case 2:
            // Pass in the binding $input
            StoolView(
                input: $viewModel.input,
                stoolConsistency: $viewModel.input.stoolConsistency,
                stoolUrgency: $viewModel.input.stoolUrgency,
                stoolEffort: $viewModel.input.stoolEffort
            )
        case 3:
            EpisodeView(episodeToView: viewModel.builtEpisode)
        default:
            // Pass in the current View's input state
            BackgroundView(
                onset: $viewModel.input.onset,
                movement: $viewModel.input.movement,
                intensity: $viewModel.input.intensity,
                stress: $viewModel.input.stress,
                bloating: $viewModel.input.bloating
            )
        }
    }
        
    // Change the toolbar items based on the user's step
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if viewModel.step > 1 {
                Button {
                    viewModel.step -= 1
                } label: {
                    Image(systemName: "chevron.backward")
                }
            } else {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            if viewModel.step < 3 {
                Button {
                    viewModel.step += 1
                } label: {
                    Image(systemName: "chevron.forward")
                }
            } else {
                Button() {
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

#Preview {
    EpisodeLoggingView()
}
