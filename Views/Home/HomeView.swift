//
//  HomeView.swift
//
//  This view holds the app's home screen.
//
import SwiftUI

struct HomeView: View {
    // State to track if the user clicked the "Log Episode" button
    @State private var showEpisodeLogger = false
    
    // State to track if the user clicked the "Log Foods" button
    @State private var showFoodLogger = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                
                // Homepage welcome
                VStack(spacing: 12) {
                    Image(systemName: "figure.mind.and.body")
                        .font(.system(size: 48))
                        .foregroundStyle(.accent)
                    
                    Text("Track Meals and IBS Episodes")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Uncover invisible patterns behind your symptoms.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
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
                .padding(.horizontal, 48)
                // Direct the user to the logging view after clicking the log button
                .sheet(isPresented: $showEpisodeLogger) {
                    EpisodeLoggingView()
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
                .padding(.horizontal, 48)
                // Direct the user to the logging view after clicking the log button
                .sheet(isPresented: $showFoodLogger) {
                    FoodLoggingView()
                }
                
                Spacer()
            }
            .navigationTitle("Home")
        }
    }
}
