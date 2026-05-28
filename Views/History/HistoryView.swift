//
//  HistoryView.swift
//  ibsapp
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
    
    // Track currently selected episode
    @State private var selectedEpisode: Episode? = nil
    
    // enum for Episode or Meal history
    enum HistoryType: String, CaseIterable, Identifiable {
        case episodes = "Episodes"
        case meals = "Meals"
        
        var id: Self { self }
    }
    
    // State to track which type of history to display to the user
    @State private var selectedView: HistoryType = .episodes
    
    // Search bar text
    @State private var searchText = ""
    
    // Filter episodes based on search text (will not be filtered if search text is empty)
    private var filteredEpisodes: [Episode] {
        // Show all episodes if search is empty
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return episodes
        }
        
        let query = searchText.lowercased()
        
        return episodes.filter { episode in
            // Search intensity
            let intensityMatch = "\(episode.intensity)".contains(query)
            
            // Search stress level
            let stressMatch = "\(episode.stress)".contains(query)
            
            // Search bloating
            let bloatingMatch = episode.bloating && "bloating".contains(query)
            
            // Search onset date
            let onsetMatch = episode.onset.formatted(.dateTime.month(.wide).day())
                .lowercased()
                .contains(query)
            
            // Search movement date
            let movementMatch = episode.movement.formatted(.dateTime.month(.wide).day())
                .lowercased()
                .contains(query)
            
            // Search stool consistency
            let stoolConsistencyMatch = "\(episode.stool_consistency)".contains(query)
            
            // Search stool urgency
            let stoolUrgencyMatch = "\(episode.stool_urgency)".contains(query)
            
            // Search stool effort
            let stoolEffortMatch = "\(episode.stool_effort)".contains(query)
            
            return intensityMatch
            || stressMatch
            || bloatingMatch
            || onsetMatch
            || movementMatch
            || stoolConsistencyMatch
            || stoolUrgencyMatch
            || stoolEffortMatch
        }
    }
    
    // Filter meals based on search text (will not be filtered if search text is empty)
    private var filteredMeals: [Meal] {
        // Show all episodes if search is empty
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return meals
        }
        
        let query = searchText.lowercased()
        
        return meals.filter { meal in
            // Search meal date
            let dateMatch = meal.date.formatted(.dateTime.month(.wide).day())
                .lowercased()
                .contains(query)
                
            // Search foods
            let foodsMatch = meal.foods.contains { food in
                food.name
                    .lowercased()
                    .contains(query)
            }
            
            return dateMatch || foodsMatch
        }
    }
    
    
    var body: some View {
        NavigationStack {
            // Allow user to go between viewing episodes and meals
            VStack {
                Picker("History Type", selection: $selectedView) {
                    ForEach(HistoryType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                historyContent
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("History")
        }
    }
    
    // Build the view depending on what the user has selected
    @ViewBuilder
    private var historyContent: some View {
        switch selectedView {
        case .episodes:
            episodeView
        case .meals:
            mealView
        }
    }
    
    // Display episodes if the user selected to view episodes
    private var episodeView: some View {
        List {
            if episodes.isEmpty {
                ContentUnavailableView(
                    searchText.isEmpty ? "No Episodes" : "No Results",
                    systemImage: searchText.isEmpty
                    ? "clock.arrow.trianglehead.counterclockwise.rotate.90"
                    : "magnifyingglass",
                    description: Text(
                        searchText.isEmpty
                        ? "No episodes to display."
                        : "No matching episodes found."
                    )
                )
                .listRowBackground(Color.clear)
                .foregroundStyle(.secondary)
            } else {
                ForEach(filteredEpisodes) { episode in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(episode.onset.formatted(date: .long, time: .shortened))
                            .font(.headline)
                        
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
                        selectedEpisode = episode
                    }
                }
                .onDelete(perform: deleteEpisode)
                .sheet(item: $selectedEpisode) { episode in
                    episodeSheet(for: episode)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search episodes…")
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
                        selectedEpisode = nil
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
                    searchText.isEmpty ? "No Meals" : "No Results",
                    systemImage: searchText.isEmpty
                    ? "clock.arrow.trianglehead.counterclockwise.rotate.90"
                    : "magnifyingglass",
                    description: Text(
                        searchText.isEmpty
                        ? "No meals to display."
                        : "No matching meals found."
                    )
                )
                .listRowBackground(Color.clear)
                .foregroundStyle(.secondary)
            } else {
                ForEach(filteredMeals) { meal in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(meal.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.headline)
                        
                        Text("Foods: " + meal.foods.map { $0.name }.joined(separator: ", "))
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .onDelete(perform: deleteMeal)
            }
        }
        .searchable(text: $searchText, prompt: "Search meals…")
        .autocorrectionDisabled()
    }
    
    // Delete an episode from the app's data
    func deleteEpisode(at offsets: IndexSet) {
        for index in offsets {
            let item = filteredEpisodes[index]
            modelContext.delete(item)
        }
        
        try? modelContext.save()
    }
    
    // Delete a meal from the app's data
    func deleteMeal(at offsets: IndexSet) {
        for index in offsets {
            let item = filteredMeals[index]
            modelContext.delete(item)
        }
        
        try? modelContext.save()
    }

}
