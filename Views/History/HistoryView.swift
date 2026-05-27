//
//  HistoryView.swift
//  ibsapp
//
//  This view displays the user's episodes as a searchable scrollable list.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    
    // Get all episodes sorted newest first
    @Query(sort: \Episode.onset, order: .reverse)
    private var episodes: [Episode]
    
    // Access SwiftData model context
    @Environment(\.modelContext) private var modelContext
    
    // Track currently selected episode
    @State private var selectedEpisode: Episode? = nil
    
    // Search bar text
    @State private var searchText = ""
    
    
    /*
     * Filter episodes based on search text.
     */
    var filteredEpisodes: [Episode] {
        
        // Show all episodes if search is empty
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return episodes
        }
        
        let query = searchText.lowercased()
        
        return episodes.filter { episode in
            
            // Search intensity
            let intensityMatch =
                "\(episode.intensity)".contains(query)
            
            // Search stress level
            let stressMatch =
                "\(episode.stress)".contains(query)
            
            // Search bloating
            let bloatingMatch =
                episode.bloating &&
                "bloating".contains(query)
            
            // Search onset date
            let onsetMatch =
                episode.onset.formatted(
                    date: .abbreviated,
                    time: .shortened
                )
                .lowercased()
                .contains(query)
            
            // Search movement date
            let movementMatch =
                episode.movement.formatted(
                    date: .abbreviated,
                    time: .shortened
                )
                .lowercased()
                .contains(query)
            
            // Search foods
            let foodsMatch =
                episode.foods.contains { food in
                    food.name
                        .lowercased()
                        .contains(query)
                }
            
            // Search stool entries
            let stoolsMatch =
                episode.stools.contains(where: { stool in
                    stool.rawValue
                        .lowercased()
                        .contains(query)
                })
            
            return intensityMatch
                || stressMatch
                || bloatingMatch
                || onsetMatch
                || movementMatch
                || foodsMatch
                || stoolsMatch
        }
    }
    
    
    var body: some View {
        
        NavigationStack {
            
            // Always render the List so .searchable() has a stable host view.
            // Moving the empty state inside the List prevents the search bar
            // from disappearing when there are no results.
            List {
                
                if filteredEpisodes.isEmpty {
                    
                    // Empty state
                    ContentUnavailableView(
                        searchText.isEmpty ? "No Episodes" : "No Results",
                        systemImage: searchText.isEmpty
                            ? "list.bullet"
                            : "magnifyingglass",
                        description: Text(
                            searchText.isEmpty
                                ? "No episodes to display."
                                : "No matching episodes found."
                        )
                    )
                    .listRowBackground(Color.clear)
                    
                } else {
                    
                    ForEach(filteredEpisodes) { episode in
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text(
                                episode.onset.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                )
                            )
                            .font(.headline)
                            
                            Text("Intensity: \(episode.intensity) / 10")
                                .font(.subheadline)
                            
                            Text("Stress: \(episode.stress) / 10")
                                .font(.subheadline)
                            
                            if episode.bloating {
                                Text("Bloating")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            }
                            
                            // Foods preview
                            if !episode.foods.isEmpty {
                                
                                Text(
                                    "Foods: " +
                                    episode.foods
                                        .map { $0.name }
                                        .joined(separator: ", ")
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                            }
                        }
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedEpisode = episode
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
            }
            .searchable(
                text: $searchText,
                prompt: "Search episodes"
            )
            .autocorrectionDisabled()
            .navigationTitle("History")
        }
        
        
        // Episode details popup
        .sheet(item: $selectedEpisode) { episode in
            
            NavigationStack {
                
                ScrollView {
                    
                    VStack(spacing: 16) {
                        
                        EpisodeView(episodeToView: episode)
                            .padding()
                            .frame(maxWidth: 400)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.secondarySystemGroupedBackground))
                                    .shadow(
                                        color: .black.opacity(0.08),
                                        radius: 8,
                                        y: 4
                                    )
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
    }
    
    
    /*
     * Delete an episode.
     */
    func deleteItem(at offsets: IndexSet) {
        
        for index in offsets {
            let item = filteredEpisodes[index]
            modelContext.delete(item)
        }
        
        try? modelContext.save()
    }
}


#Preview {
    HistoryView()
}
