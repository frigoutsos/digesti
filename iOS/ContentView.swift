//
//  ContentView.swift
//
//  This view structures the layout of the app.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    // Get access to the model context to pass to the watch handler
    @Environment(\.modelContext) private var modelContext

    // Load our navigation manager
    @State private var navigationManager = NavigationManager.shared
    
    // Load our health service
    @State private var healthService = HealthKitService.shared
  
    var body: some View {
        @Bindable var navigationManager = navigationManager
        
        VStack {
            // Set up the bottom TabView
            TabView(selection: $navigationManager.selectedTab) {
                
                Tab(value: .home) {
                    NavigationStack {
                        HomeView(navigationManager: navigationManager)
                    }
                } label: {
                    Label(TabType.home.id, systemImage: "house.fill")
                }
                
                Tab(value: .calendar) {
                    NavigationStack {
                        CalendarView()
                    }
                } label: {
                    Label(TabType.calendar.id, systemImage: "calendar")
                }
                
                Tab(value: .history) {
                    NavigationStack {
                        HistoryView(navigationManager: navigationManager)
                    }
                } label: {
                    Label(TabType.history.id, systemImage: "clock")
                }
                
                Tab(value: .insights) {
                    NavigationStack {
                        InsightsView()
                    }
                } label: {
                    Label(TabType.insights.id, systemImage: "lightbulb.fill")
                }
                
                Tab(value: .settings) {
                    NavigationStack {
                        SettingsView()
                    }
                } label: {
                    Label(TabType.settings.id, systemImage: "gearshape.fill")
                }
            }
            .tint(.accent)
            .task {
                // Start WatchConnectivity handler
                WatchConnectivityHandler.shared.start(with: modelContext)
            }
        }
        .environment(navigationManager)
        .onAppear {
            Task {
                await healthService.requestAuthorization()
            }
        }
    }
}
