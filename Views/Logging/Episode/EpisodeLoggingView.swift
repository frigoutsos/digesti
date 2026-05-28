//
//  LoggingView.swift
//  ibsapp
//
//  This view guides the user through logging episodes.
//
import SwiftUI
import SwiftData

struct EpisodeLoggingView: View {
    // Access the configured model context
    @Environment(\.modelContext) private var context
    
    // Allow the user to click cancel and dismiss the logging flow
    @Environment(\.dismiss) private var dismiss
    
    // State to track which step the user is on
    @State private var step: Int = 1
    
    // State of the user's input as they go through the screen
    @State private var input = EpisodeInput()
    
    // State to track if we saved a user's episode yet
    @State private var didSave = false
    
    var body: some View {
        // Change the view programatically as the user clicks through the prompts
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Programmatically change the content displayed based on the user's step
                stepContent
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
        }
    }
    
    // Change the content to display above based on the user's step
    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case 1:
            // Pass in the current View's input state
            BackgroundView(
                onset: $input.onset,
                movement: $input.movement,
                intensity: $input.intensity,
                stress: $input.stress,
                bloating: $input.bloating
            )
        case 2:
            // Pass in the binding $input
            StoolView(
                input: $input,
                stool_consistency: $input.stool_consistency,
                stool_urgency: $input.stool_urgency,
                stool_effort: $input.stool_effort
            )
        case 3:
            SummaryView(builtEpisode: builtEpisode)
        default:
            // Pass in the current View's input state
            BackgroundView(
                onset: $input.onset,
                movement: $input.movement,
                intensity: $input.intensity,
                stress: $input.stress,
                bloating: $input.bloating
            )
        }
    }
    
    // Computed property to change the title based on the user's step
    private var navigationTitle: String {
        switch step {
        case 1: return "Background"
        case 2: return "Recent Stool"
        case 3: return "Summary"
        default: return ""
        }
    }
    
    // Change the toolbar items based on the user's step
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if step > 1 {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back") {
                    step -= 1
                }
            }
        } else {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            if step < 3 {
                Button("Next") {
                    step += 1
                }
            } else {
                Button("Done") {
                    saveEpisode()
                }
                // Provide user with a success haptic upon saving the episode
                .sensoryFeedback(.success, trigger: didSave)
            }
        }
    }
    
    // Computed property to build the episode on-the-fly
    private var builtEpisode: Episode {
        Episode(
            onset: input.onset,
            movement: input.movement,
            intensity: Int(input.intensity),
            stress: Int(input.stress),
            bloating: input.bloating,
            stool_consistency: Int(input.stool_consistency),
            stool_urgency: Int(input.stool_urgency),
            stool_effort: Int(input.stool_effort)
        )
    }
    
    // Function to save a episode when the user is done with the input flow
    private func saveEpisode() {
        if (!didSave) {
            context.insert(builtEpisode)
            
            do {
                try context.save()
                didSave = true
                dismiss()
            } catch {
                print("Error saving episode:", error)
            }
        }
    }
}
