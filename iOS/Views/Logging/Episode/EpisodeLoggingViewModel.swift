//
//  EpisodeLoggingViewModel.swift
//
//  ViewModel to handle calculations related to episode logging.
//
import SwiftUI
import SwiftData

@Observable
class EpisodeLoggingViewModel {
    // Track which step the user is on
    var step: Int = 1
    
    // Track the user's input as they go through the screen
    var input: EpisodeInput = EpisodeInput()
    
    // Track if we saved a user's episode yet
    var didSave: Bool = false
    
    // Computed property to build the episode on-the-fly
    var builtEpisode: Episode {
        Episode(
            onset: input.onset,
            movement: input.movement,
            intensity: Int(input.intensity),
            stress: Int(input.stress),
            bloating: input.bloating,
            stoolConsistency: Int(input.stoolConsistency),
            stoolUrgency: Int(input.stoolUrgency),
            stoolEffort: Int(input.stoolEffort)
        )
    }
    
    // Computed property to change the title based on the user's step
    var navigationTitle: String {
        switch step {
        case 1: return "Background"
        case 2: return "Recent Stool"
        case 3: return "Summary"
        default: return ""
        }
    }
    
    
    // Function to save a episode when the user is done with the input flow
    func saveEpisode(modelContext: ModelContext) throws {
        guard !didSave else { return }
        
        modelContext.insert(builtEpisode)
        try modelContext.save()
        didSave = true
    }
}
