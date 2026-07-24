//
//  EpisodeInput.swift
//
//  Contains a temporary object to hold user input, which will be turned into an Episode object.
//
import SwiftUI

// A generalized structure to hold transient user input for any episode type being logged.
// This includes all possible fields to accommodate different episode types.
struct EpisodeInput: Codable {
    // Common fields for all episode types
    var onset: Date = Date()
    var stress: Int = 3 // Applicable to all episode types
    
    // Fields specific to Stool Episodes
    var stoolUrgency: Int?
    var stoolEffort: Int?
    var stoolConsistency: Int?
    
    // Fields specific to Bloating Episodes
    var intensity: Int?
}
