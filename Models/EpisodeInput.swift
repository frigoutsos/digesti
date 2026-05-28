//
//  EpisodeInput.swift
//  ibsapp
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
    var stool_consistency: Double = 5
    var stool_urgency: Double = 5
    var stool_effort: Double = 5
}
