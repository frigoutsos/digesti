//
//  EpisodeView.swift
//
//  This file creates a view that displays information of an episode.
import SwiftUI

struct EpisodeView: View {
    // Take in an Episode object to display in this view
    let episode: Episode

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    switch episode {
                    case .bloating(let episode):
                        BloatingEpisodeView(episodeToView: episode)
                    case .constipation(let episode):
                        ConstipationEpisodeView(episodeToView: episode)
                    case .stool(let episode):
                        StoolEpisodeView(episodeToView: episode)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding()
    }
}
