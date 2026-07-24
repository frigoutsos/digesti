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
    var step: LoggingStep?
    
    // Track the user's input as they go through the screen
    var input: EpisodeInput = EpisodeInput()
    
    // Track if we saved a user's episode yet
    var didSave: Bool = false
    
    // Keep track of if we have selected bloating
    var hasSelectedBloating: Bool? = nil
    
    // Keep track of what type of episode the user wants to log
    var episodeType: EpisodeType?
    
    // Keep track if the user wants the Bristol stool reference sheet
    var presentStoolSheet: Bool = false
    
    // Function to save a episode when the user is done with the input flow
    func saveEpisode(modelContext: ModelContext) throws {
        guard !didSave else { return }
        
        guard let type = episodeType else { return }
        
        let builtEpisode = EpisodeBuilder.build(from: input, type: type)
        modelContext.insert(builtEpisode)
        
        try modelContext.save()
        didSave = true
    }
}
