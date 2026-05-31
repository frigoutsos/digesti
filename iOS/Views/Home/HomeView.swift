//
//  HomeView.swift
//
//  This view holds the app's home screen.
//
import SwiftUI

struct HomeView: View {
    // Track our navigation manager component
    @Bindable var navigationManager: NavigationManager
    
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
                    navigationManager.presentEpisodeLogger()
                } label: {
                    Label("Log Episode", systemImage: "bolt.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
                .padding(.horizontal, 48)
                
                Button {
                    navigationManager.presentMealLogger()
                } label: {
                    Label("Log Meal", systemImage: "fork.knife")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
                .padding(.horizontal, 48)
                
                Spacer()
            }
            .navigationTitle("Home")
            // Direct the user to the logging view after clicking the log button
            .sheet(item: $navigationManager.activeSheet) { (sheetType: NavigationManager.SheetType) in
                switch sheetType {
                case .episode:
                    EpisodeLoggingView()
                case .meal:
                    MealLoggingView()
                }
            }
        }
    }
}
