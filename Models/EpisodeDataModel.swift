//
//  EpisodeDataModel.swift
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
    var foods: [Food]
    var stools: [Stool]
    
    // Assign data to each field in the initializer
    init(
        onset: Date,
        movement: Date,
        intensity: Int,
        stress: Int,
        bloating: Bool,
        foods: [Food],
        stools: [Stool]
    ) {
        self.onset = onset
        self.movement = movement
        self.intensity = intensity
        self.stress = stress
        self.bloating = bloating
        self.foods = foods
        self.stools = stools
    }
}
