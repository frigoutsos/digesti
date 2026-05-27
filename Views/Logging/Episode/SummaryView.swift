//
//  SummaryView.swift
//
//  Display the user a summary of the episode they entered
//
import SwiftUI

struct SummaryView: View {
    // Take in the episode we built
    let builtEpisode: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Review your episode:")
                .font(.headline)
                .foregroundStyle(.primary)
            
            ScrollView {
                EpisodeView(episodeToView: builtEpisode)
            }
        }
        .padding()
    }
}
