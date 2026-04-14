//
//  App.swift
//  AheadAche
//
//  This contains the App's top level logic.
//
//  Created by Franklin Rigoutsos on 1/20/26.
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
        .modelContainer(for: Headache.self)
    }
}
