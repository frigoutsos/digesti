//
//  Episode.swift
//
//  This is the SwiftUI data model that represents all episode objects.
//
import SwiftUI
import SwiftData

@Model
final class Episode {
    // Fields of an episode
    var onset: Date
    var movement: Date
    var intensity: Int
    var stress: Int
    var bloating: Bool
    var stoolConsistency: Int
    var stoolUrgency: Int
    var stoolEffort: Int
    
    // Assign data to each field in the initializer
    init(
        onset: Date,
        movement: Date,
        intensity: Int,
        stress: Int,
        bloating: Bool,
        stoolConsistency: Int,
        stoolUrgency: Int,
        stoolEffort: Int
    ) {
        self.onset = onset
        self.movement = movement
        self.intensity = intensity
        self.stress = stress
        self.bloating = bloating
        self.stoolConsistency = stoolConsistency
        self.stoolUrgency = stoolUrgency
        self.stoolEffort = stoolEffort
    }
}
