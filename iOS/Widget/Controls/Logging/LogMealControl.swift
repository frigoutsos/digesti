//
//  LogMealControl.swift
//
//  Control center toggle to quickly log a meal.
//
import AppIntents
import SwiftUI
import WidgetKit

struct LogMealControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "dev.ibsapp.LogMealControl") {
            ControlWidgetButton(action: LogMealIntent()) {
                Label("Log Meal", systemImage: "fork.knife")
            }
        }
        .displayName("Log Meal")
        .description("Quickly log a recent meal.")
    }
}
