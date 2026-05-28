//
//  ContentView.swift
//  ibs-app
//
//  This view structures the layout of the app.
//
import SwiftUI

struct ContentView: View {    
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
        }
    }
}

#Preview {
    ContentView()
}
