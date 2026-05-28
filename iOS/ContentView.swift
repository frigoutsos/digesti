//
//  ContentView.swift
//
//  This view structures the layout of the app.
//
import SwiftUI

struct ContentView: View {
    // Get access to the model context to pass to the watch handler
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            // Set up the bottom TabView
            TabView {
                Tab("Home", systemImage: "house.fill") {
                    NavigationStack {
                        HomeView()
                    }
                }
                
                Tab("Calendar", systemImage: "calendar") {
                    NavigationStack {
                        CalendarView()
                    }
                }
                
                Tab("History", systemImage: "clock") {
                    NavigationStack {
                        HistoryView()
                    }
                }
                
                Tab("Insights", systemImage: "lightbulb") {
                    NavigationStack {
                        InsightsView()
                    }
                }
                
                Tab("Settings", systemImage: "gearshape.fill") {
                    NavigationStack {
                        SettingsView()
                    }
                }
            }
            .tint(.accent)
            .task {
                // Start WatchConnectivity handler
                WatchConnectivityHandler.shared.start(with: modelContext)
            }
        }
    }
}
