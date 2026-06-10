//
//  EpisodeInput.swift
//
//  Contains a temporary object to hold user input, which will be turned into an Episode object.
//
import SwiftUI

struct EpisodeInput: Codable {
    var onset: Date = Date()
    var movement: Date = Date()
    var intensity: Int = 3
    var stress: Int = 3
    var bloating: Bool = false
    var stoolConsistency: Int = 4
    var stoolUrgency: Int = 3
    var stoolEffort: Int = 3
}
