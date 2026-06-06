//
//  HistoryView.swift
//
//  This view displays the user's episodes as a searchable scrollable list.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    // Access the configured model context
    @Environment(\.modelContext) private var modelContext
    
    // Get a list of episodes, reverse sorted by time
    @Query(sort: \Episode.onset, order: .reverse) private var episodes: [Episode]
    
    // Get a list of meals, reverse sorted by time
    @Query(sort: \Meal.date, order: .reverse) private var meals: [Meal]
    
    // State to keep track of our ViewModel object
    @State private var viewModel = HistoryViewModel()
    
    // Track our navigation manager component
    @Bindable var navigationManager: NavigationManager

    var body: some View {
        NavigationStack {
            // Allow user to go between viewing episodes and meals
            VStack {
                Picker("History Type", selection: $navigationManager.activeHistory) {
                    ForEach(NavigationManager.HistoryType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Choose which history to show depending on the user's selection
                switch navigationManager.activeHistory {
                case .episode:
                    episodeView
                case .meal:
                    mealView
                case .none:
                    episodeView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("History")
        }
    }
    
    // Display episodes if the user selected to view episodes
    private var episodeView: some View {
        List {
            if episodes.isEmpty {
                ContentUnavailableView(
                    viewModel.searchText.isEmpty ? "No Episodes" : "No Results",
                    systemImage: viewModel.searchText.isEmpty
                    ? "clock.arrow.trianglehead.counterclockwise.rotate.90"
                    : "magnifyingglass",
                    description: Text(
                        viewModel.searchText.isEmpty
                        ? "No episodes to display."
                        : "No matching episodes found."
                    )
                )
                .listRowBackground(Color.clear)
                .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.filteredEpisodes(from: episodes)) { episode in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(episode.onset.formatted(date: .long, time: .shortened))
                            .font(.headline)
                        
                        Divider()
                        
                        Text("Bowel movement: \(episode.movement.formatted(date: .long, time: .shortened))")
                            .font(.subheadline)
                        
                        Text("Intensity: \(episode.intensity) / 10")
                            .font(.subheadline)
                        
                        Text("Stress: \(episode.stress) / 10")
                            .font(.subheadline)
                        
                        if episode.bloating {
                            Text("Bloating")
                                .font(.subheadline)
                                .foregroundStyle(.accent)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    // Set the selected episode state when clicking on it
                    .onTapGesture {
                        viewModel.selectedEpisode = episode
                    }
                }
                // Delete an episode from the app's data
                .onDelete { indexSet in
                    indexSet.map { viewModel.filteredEpisodes(from: episodes)[$0] }.forEach(modelContext.delete)
                        try? modelContext.save()
                }
                .sheet(item: $viewModel.selectedEpisode) { episode in
                    episodeSheet(for: episode)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search episodes…")
        .autocorrectionDisabled()
    }
    
    // Logic to pop open sheets
    private func episodeSheet(for episode: Episode) -> some View {
        NavigationStack {
            // Allow scrolling through summary view for those using larger text sizes
            ScrollView {
                VStack(spacing: 16) {
                    EpisodeView(episodeToView: episode)
                        .padding()
                        .frame(maxWidth: 400)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.secondarySystemGroupedBackground))
                                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                        )
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Episode Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        viewModel.selectedEpisode = nil
                    }
                }
            }
        }
    }
    
    // Display meals if the user selected to view meals
    private var mealView: some View {
        List {
            if meals.isEmpty {
                ContentUnavailableView(
                    viewModel.searchText.isEmpty ? "No Meals" : "No Results",
                    systemImage: viewModel.searchText.isEmpty
                    ? "clock.arrow.trianglehead.counterclockwise.rotate.90"
                    : "magnifyingglass",
                    description: Text(
                        viewModel.searchText.isEmpty
                        ? "No meals to display."
                        : "No matching meals found."
                    )
                )
                .listRowBackground(Color.clear)
                .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.filteredMeals(from: meals)) { meal in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(meal.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.headline)
                        
                        Divider()
                        
                        Text("Foods: " + meal.foods.map { $0.name }.joined(separator: ", "))
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                // Delete a meal from the app's data
                .onDelete { indexSet in
                    indexSet.map { viewModel.filteredMeals(from: meals)[$0] }.forEach(modelContext.delete)
                        try? modelContext.save()
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search meals…")
        .autocorrectionDisabled()
    }
}
