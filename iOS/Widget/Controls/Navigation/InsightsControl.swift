//
//  Insights.swift
//
//  Control center toggle to quickly view insights.
//
import AppIntents
import SwiftUI
import WidgetKit

struct InsightsControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "dev.daemon.digesti.InsightsControl") {
            ControlWidgetButton(action: ViewInsightsIntent()) {
                Label("Insights", systemImage: "lightbulb.fill")
            }
        }
        .displayName("Insights")
        .description("Quickly view insights.")
    }
}

