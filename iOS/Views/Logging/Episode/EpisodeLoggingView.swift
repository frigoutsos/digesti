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
                switch viewModel.episodeType {
                case .stool:
                    StoolLogger(viewModel: $viewModel)
                case .constipation:
                    ConstipationLogger(viewModel: viewModel)
                case .bloating:
                    BloatingLogger(viewModel: viewModel)
                case nil:
                    EpisodeTypeChooser(episodeType: $viewModel.episodeType)
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
