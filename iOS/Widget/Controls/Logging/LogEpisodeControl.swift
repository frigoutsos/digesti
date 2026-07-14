//
//  LogEpisodeControl.swift
//
//  Control center toggle to quickly log an episode.
//
import AppIntents
import SwiftUI
import WidgetKit

struct LogEpisodeControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "dev.daemon.digesti.LogEpisodeControl") {
            ControlWidgetButton(action: LogEpisodeIntent()) {
                Label("Log Episode", systemImage: "bolt.fill")
            }
        }
        .displayName("Log Episode")
        .description("Quickly log a recent IBS episode.")
    }
}
