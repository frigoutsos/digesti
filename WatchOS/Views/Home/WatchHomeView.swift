//
//  WatchHomeView.swift
//
//  Contains a home view for the watch companion app.
//
import SwiftUI

struct WatchHomeView: View {
    // State to track if the user clicked the "Log Episode" button
    @State private var showEpisodeLogger = false
    
    // State to track if the user clicked the "Log Foods" button
    @State private var showFoodLogger = false
    
    var body: some View {
        Button {
            showEpisodeLogger = true
        } label: {
            Label("Log Episode", systemImage: "bolt.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .tint(.accent)
        .padding()
        // Direct the user to the logging view after clicking the log button
        .sheet(isPresented: $showEpisodeLogger) {
            EpisodeLoggingWatchView()
        }
        
        Button {
            showFoodLogger = true
        } label: {
            Label("Log Meal", systemImage: "fork.knife")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .tint(.accent)
        .padding()
        // Direct the user to the logging view after clicking the log button
        .sheet(isPresented: $showFoodLogger) {
            MealLoggingWatchView()
        }
    }
}

#Preview {
    WatchHomeView()
}
