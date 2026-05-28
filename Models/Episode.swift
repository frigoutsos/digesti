//
//  Episode.swift
//  ibsapp
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
    var stool_consistency: Int
    var stool_urgency: Int
    var stool_effort: Int
    
    // Assign data to each field in the initializer
    init(
        onset: Date,
        movement: Date,
        intensity: Int,
        stress: Int,
        bloating: Bool,
        stool_consistency: Int,
        stool_urgency: Int,
        stool_effort: Int
    ) {
        self.onset = onset
        self.movement = movement
        self.intensity = intensity
        self.stress = stress
        self.bloating = bloating
        self.stool_consistency = stool_consistency
        self.stool_urgency = stool_urgency
        self.stool_effort = stool_effort
    }
}
