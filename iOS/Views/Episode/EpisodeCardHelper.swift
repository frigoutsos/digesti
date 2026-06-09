//
//  EpisodeCardHelper.swift
//
//  Defines custom helper methods for use in Episode cards.
//
import SwiftUI

// Get color ranks low values as good (since the metrics we track are mostly negative)
func getColor(for value: Int, reversed: Bool = false) -> Color {
    guard value >= 0 && value <= 10 else { return Color.primary }
    
    if (value <= 3) {
        return reversed ? Color.red : Color.green
    } else if (value < 8) {
        return Color.yellow
    } else {
        return reversed ? Color.green : Color.red
    }
}
