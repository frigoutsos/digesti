//
//  App.swift
//  ibs-app
//
//  This contains the App's top level logic.
//
import SwiftUI
import SwiftData

@main
struct MyApp: App {
    // Get the user's preference for a theme
    @AppStorage("appTheme") private var appThemeRawValue: String = AppTheme.system.rawValue

    private var selectedTheme: AppTheme {
        AppTheme(rawValue: appThemeRawValue) ?? .system
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Allow for custom appearance set by user (do not always use system)
                .preferredColorScheme(selectedTheme.colorScheme)
        }
        // Set up the SwiftData model container
        .modelContainer(for: [Episode.self, Meal.self])
    }
}
