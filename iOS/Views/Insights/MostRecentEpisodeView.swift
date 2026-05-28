//
//  MostRecentEpisodeView.swift
//
//  This view creates a card to display a summary of lifetime episodes.
//
import SwiftUI

struct MostRecentEpisodeView: View {
    // The user may not have inputted any episodes yet, so make this input optional
    let mostRecentEpisode: Episode?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Title
            HStack(spacing: 8) {
                Label("Most Recent Episode", systemImage: "clock.arrow.circlepath")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                // If there is an episode to display, create an EpisodeView card
                if let episode = mostRecentEpisode {
                    EpisodeView(episodeToView: episode)
                // Otherwise, tell the user there are no episodes to display
                } else {
                    Text("No episodes to display.")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}
