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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Set up the SwiftData model container
        .modelContainer(for: Episode.self)
    }
}
