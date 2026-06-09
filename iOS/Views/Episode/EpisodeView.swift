//
//  EpisodeView.swift
//
//  This file creates a view that displays information of an episode.
import SwiftUI

struct EpisodeView: View {
    // Take in an Episode object to display in this view
    let episodeToView: Episode

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    EpisodeTimingCard(episodeToView: episodeToView)
                        .background(.accent.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    EpisodeSymptomsCard(episodeToView: episodeToView)
                        .background(.accent.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                   
                   EpisodeStoolCard(episodeToView: episodeToView)
                       .background(.accent.opacity(0.15))
                       .clipShape(RoundedRectangle(cornerRadius: 16))

                }
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding()
    }
}
