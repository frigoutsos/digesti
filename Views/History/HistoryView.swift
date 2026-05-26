//
//  HistoryView.swift
//  ibs-app
//
//  This view displays the user's episodes as a scrollable list.
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
    
    // State to track selected episode being viewed, if any
    @State private var selectedEpisode: Episode? = nil
    
    // enum for Episode or Meal history
    enum HistoryType: String, CaseIterable, Identifiable {
        case episodes = "Episodes"
        case meals = "Meals"
        
        var id: Self { self }
    }
    
    // State to track which type of history to display to the user
    @State private var selectedView: HistoryType = .episodes
    
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
        Group {
            if episodes.isEmpty {
                Text("No episodes to display.")
                    .foregroundStyle(.secondary)
            } else {
                List {
                    ForEach(episodes) { episode in
                        VStack(alignment: .leading) {
                            Text(episode.onset.formatted(date: .abbreviated, time: .shortened))
                                .font(.headline)
                            Text("Intensity: \(episode.intensity) / 10")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        // Set the selected episode state when clicking on it
                        .onTapGesture {
                            selectedEpisode = episode
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
                .sheet(item: $selectedEpisode) { episode in
                    episodeSheet(for: episode)
                }
            }
        }
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
        Group {
            if meals.isEmpty {
                Text("No meals to display.")
                    .foregroundStyle(.secondary)
            } else {
                List {
                    ForEach(meals) { meal in
                        VStack(alignment: .leading) {
                            Text(meal.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.headline)
                            Text("Foods: " + meal.foods.map { $0.name }.joined(separator: ", "))
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .onDelete(perform: deleteItem)
                }
            }
        }
    }

    
    /*
     * Function to delete an episode from the list and the SwiftData model.
     */
    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = episodes[index]
            modelContext.delete(item)
        }
        
        try? modelContext.save()
    }
}
