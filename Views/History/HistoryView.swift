//
//  HistoryView.swift
//  ibs-app
//
//  This view displays the user's episodes as a scrollable list.
//
import SwiftUI
import SwiftData

struct HistoryView: View {
    // Get a list of episodes, reverse sorted by time
    @Query(sort: \Episode.onset, order: .reverse) private var episodes: [Episode]
    
    // Access the configured model context
    @Environment(\.modelContext) private var modelContext
    
    // State to track selected episode being viewed, if any
    @State private var selectedEpisode: Episode? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                // If there are no episodes, inform the user
                if (episodes.isEmpty) {
                    Text("No episodes to display.")
                        .foregroundStyle(.secondary)
                // Otherwise, display all the episodes in a list
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
                    // A sheet will popup when the user clicks an episode
                    .sheet(item: $selectedEpisode) { episode in
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
                }
            }
            .navigationTitle("History")
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

#Preview {
    HistoryView()
}
