//
//  WatchHomeView.swift
//
//  Contains a home view for the watch companion app.
//
import SwiftUI

struct WatchHomeView: View {
    // State to track if the user clicked the "Log Episode" button
    @State private var showEpisodeLogger = false
        
    // State to track if the user clicked the "Log Meal" button
    @State private var showMealLogger = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                showEpisodeLogger = true
            } label: {
                Label("Log Episode", systemImage: "bolt.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            
            Button {
                showMealLogger = true
            } label: {
                Label("Log Meal", systemImage: "fork.knife")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(.accent)
        .padding()
    }
}
