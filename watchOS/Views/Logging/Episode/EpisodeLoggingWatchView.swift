//
//  EpisodeLoggingWatchView.swift
//
//  This view guides the user through logging episodes on their watch.
//
import SwiftUI

struct EpisodeLoggingWatchView: View {
    // Allow user to dismiss
    @Environment(\.dismiss) private var dismiss
    
    // State to represent the step the user is on
    @State private var step: Int = 1
    
    // State to represent the Episode as the user is building it
    @State private var input = EpisodeInput()
    
    // State to represent if we have saved the episode yet
    @State private var didSave = false

    var body: some View {
        NavigationStack {
            VStack {
                // Programmatically change the content displayed based on the user's step
                stepContent
            }
            .padding()
            // Provide user with a success haptic upon saving the episode
            .sensoryFeedback(.success, trigger: didSave)
            .toolbar {
                toolbarContent
            }
        }
    }
    
    // Computed property for the step content to display
    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case 1: OnsetView(onset: $input.onset)
        case 2: MovementView(movement: $input.movement)
        case 3: NumericView(value: $input.intensity, label: "Intensity")
        case 4: NumericView(value: $input.stress, label: "Stress")
        case 5: BloatingView(bloating: $input.bloating)
        case 6: NumericView(value: $input.stoolConsistency, label: "Stool Consistency")
        case 7: NumericView(value: $input.stoolUrgency, label: "Stool Urgency")
        case 8: NumericView(value: $input.stoolEffort, label: "Stool Effort")
        default: OnsetView(onset: $input.onset)
        }
    }
    
    // Change the toolbar items based on the user's step
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                if step > 1 {
                    step -= 1
                } else {
                    dismiss()
                }
            } label: {
                Image(systemName: step > 1 ? "chevron.backward" : "xmark")
            }
        }

        ToolbarItem(placement: .confirmationAction) {
            Button {
                if step < 8 {
                    step += 1
                } else {
                    saveEpisode()
                }
            } label: {
                Image(systemName: step < 8 ? "chevron.forward" : "checkmark")
            }
        }
    }

    // Function to save episode
    private func saveEpisode() {
        guard !didSave else { return }
        let dto = EpisodeInput(
            onset: input.onset,
            movement: input.movement,
            intensity: input.intensity,
            stress: input.stress,
            bloating: input.bloating,
            stoolConsistency: input.stoolConsistency,
            stoolUrgency: input.stoolUrgency,
            stoolEffort: input.stoolEffort
        )
        do {
            let data = try JSONEncoder().encode(dto)
            WatchMessageManager.shared.sendEpisodeData(data) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        didSave = true
                        dismiss()
                    case .failure(let error):
                        print("send error:", error)
                    }
                }
            }
        } catch {
            print("encode error:", error)
        }
    }
}
