//
//  AppWidgetBundle.swift
//
//  Creates a bundle that declares all the widgets provided by the app.
//
import WidgetKit
import SwiftUI

@main
struct AppWidgetBundle: WidgetBundle {
    var body: some Widget {
        LogEpisodeControl()
        LogMealControl()
        EpisodeHistoryControl()
        MealHistoryControl()
    }
}
