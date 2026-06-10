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
    var step: LoggingStep = .onset
    
    // Track the user's input as they go through the screen
    var input: EpisodeInput = EpisodeInput()
    
    // Track if we saved a user's episode yet
    var didSave: Bool = false
    
    // Keep track of if we have selected bloating
    var hasSelectedBloating: Bool? = nil
    
    // Keep track if the user wants the Bristol stool reference sheet
    var presentStoolSheet: Bool = false
    
    // Computed property to build the episode on-the-fly
    var builtEpisode: Episode {
        Episode(
            onset: input.onset,
            movement: input.movement,
            intensity: input.intensity,
            stress: input.stress,
            bloating: input.bloating,
            stoolConsistency: Int(input.stoolConsistency),
            stoolUrgency: input.stoolUrgency,
            stoolEffort: input.stoolEffort
        )
    }
    
    // Function to save a episode when the user is done with the input flow
    func saveEpisode(modelContext: ModelContext) throws {
        guard !didSave else { return }
        
        modelContext.insert(builtEpisode)
        try modelContext.save()
        didSave = true
    }
}

enum LoggingStep: Int, CaseIterable {
    case onset
    case movement
    case intensity
    case stress
    case bloating
    case stoolType
    case urgency
    case effort
    case summary
    
    var next: LoggingStep? {
        LoggingStep(rawValue: rawValue + 1)
    }
    
    var prev: LoggingStep? {
        LoggingStep(rawValue: rawValue - 1)
    }
}
