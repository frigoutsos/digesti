//
//  ContentView.swift
//  AheadAche
//
//  This view structures the layout of the app.
//
//  Created by Franklin Rigoutsos on 1/20/26.
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
                
                Tab("History", systemImage: "clock.fill") {
                    NavigationStack {
                        HistoryView()
                    }
                }
                
                Tab("Insights", systemImage: "lightbulb") {
                    NavigationStack {
                        InsightsView()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
