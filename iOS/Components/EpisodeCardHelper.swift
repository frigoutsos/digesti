//
//  EpisodeCardHelper.swift
//
//  Defines custom helper methods for use in Episode cards.
//
import SwiftUI

// Get color ranks low values as good (since the metrics we track are mostly negative)
func getColor(for value: Int, reversed: Bool = false) -> Color {
    guard value >= 1 && value <= 5 else { return Color.primary }
    
    if (value < 2) {
        return reversed ? Color.red : Color.green
    } else if (value < 5) {
        return Color.yellow
    } else {
        return reversed ? Color.green : Color.red
    }
}

func getEmoji(for value: Int) -> String {
    guard value >= 1 && value <= 5 else { return "" }
    
    return EmojiType.allCases[value - 1].rawValue
}
