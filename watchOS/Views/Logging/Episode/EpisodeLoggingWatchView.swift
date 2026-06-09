//
//  EpisodeLoggingWatchView.swift
//
//  This view guides the user through logging episodes on their watch.
//
import SwiftUI

struct EpisodeLoggingWatchView: View {
    // Allow user to dismiss
    @Environment(\.dismiss) private var dismiss

    // State to keep track of our ViewModel object
    @State private var viewModel = EpisodeLoggingWatchViewModel()

    // State to keep track if the user wants the Bristol stool reference sheet
    @State private var presentStoolSheet: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                // Programmatically change the content displayed based on the user's step
                stepContent
            }
            .padding()
            // Provide user with a success haptic upon saving the episode
            .sensoryFeedback(.success, trigger: viewModel.didSave)
            .toolbar {
                toolbarContent
            }
        }
    }
    
    // Computed property for the step content to display
    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.step {
        case 1: OnsetView(onset: $viewModel.input.onset)
        case 2: MovementView(movement: $viewModel.input.movement)
        case 3: NumericView(value: $viewModel.input.intensity, label: "Intensity", maxValue: 10)
        case 4: NumericView(value: $viewModel.input.stress, label: "Stress", maxValue: 10)
        case 5: BloatingView(bloating: $viewModel.input.bloating)
        case 6: VStack{
            Button {
                presentStoolSheet = true
            } label: {
                Image(systemName: "info.circle")
            }
            .sheet(isPresented: $presentStoolSheet) {
                BristolScaleListView()
            }
            NumericView(value: $viewModel.input.stoolConsistency, label: "Stool Consistency", maxValue: 7)
        }
        case 7: NumericView(value: $viewModel.input.stoolUrgency, label: "Stool Urgency", maxValue: 10)
        case 8: NumericView(value: $viewModel.input.stoolEffort, label: "Stool Effort", maxValue: 10)
        default: OnsetView(onset: $viewModel.input.onset)
        }
    }
    
    // Change the toolbar items based on the user's step
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                if viewModel.step > 1 {
                    viewModel.step -= 1
                } else {
                    dismiss()
                }
            } label: {
                Image(systemName: viewModel.step > 1 ? "chevron.backward" : "xmark")
            }
        }

        ToolbarItem(placement: .confirmationAction) {
            Button {
                if viewModel.step < 8 {
                    viewModel.step += 1
                } else {
                    viewModel.saveEpisode()
                }
            } label: {
                Image(systemName: viewModel.step < 8 ? "chevron.forward" : "checkmark")
            }
        }
    }
}
