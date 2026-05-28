//
//  EpisodeInput.swift
//
//  Contains a temporary object to hold user input, which will be turned into an Episode object.
//
import SwiftUI

struct EpisodeInput {
    var onset: Date = Date()
    var movement: Date = Date()
    var intensity: Double = 5
    var stress: Double = 5
    var bloating: Bool = false
    var stoolConsistency: Double = 5
    var stoolUrgency: Double = 5
    var stoolEffort: Double = 5
}
