//
//  MealHistoryControl.swift
//
//  Control center toggle to quickly view meal history.
//
import AppIntents
import SwiftUI
import WidgetKit

struct MealHistoryControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "dev.ibsapp.MealHHistoryControl") {
            ControlWidgetButton(action: ViewMealHistoryIntent()) {
                Label("Meal History", systemImage: "checkmark.arrow.trianglehead.counterclockwise")
            }
        }
        .displayName("Meal History")
        .description("Quickly view meal history.")
    }
}

