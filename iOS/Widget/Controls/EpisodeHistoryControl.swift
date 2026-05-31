//
//  EpisodeHistoryControl.swift
//
//  Control center toggle to quickly view episode history.
//
import AppIntents
import SwiftUI
import WidgetKit

struct EpisodeHistoryControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "dev.ibsapp.EpisodeHistoryControl") {
            ControlWidgetButton(action: ViewEpisodeHistoryIntent()) {
                Label("Episode History", systemImage: "exclamationmark.arrow.trianglehead.counterclockwise.rotate.90")
            }
        }
        .displayName("Episode History")
        .description("Quickly view episode history.")
    }
}
