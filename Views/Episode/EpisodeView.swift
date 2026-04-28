//
//  EpisodeView.swift
//  ibs-app
//
//  This file creates a view that displays information of an episode.
import SwiftUI

struct EpisodeView: View {
    // Take in an Episode object to display in this view
    let episodeToView: Episode

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Date info
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundStyle(.accent)
                
                Text("Date:")
                    .fontWeight(.semibold)
                
                Text(episodeToView.onset.formatted(date: .abbreviated, time: .shortened))
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Intensity info
            HStack(spacing: 8) {
                Image(systemName: "speedometer")
                    .foregroundStyle(.accent)
                
                Text("Intensity:")
                    .fontWeight(.semibold)
                
                Text("\(episodeToView.intensity) / 10")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)

            // Trigger(s) info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.accent)
                    .padding(.top, 2)
                
                Text("Foods:")
                    .fontWeight(.semibold)
                
                Text(episodeToView.foods.map { $0.name }.joined(separator: ", "))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Stool type(s) info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "toilet.fill")
                    .foregroundStyle(.accent)

                Text("Stool types:")
                    .fontWeight(.semibold)
                
                Text(episodeToView.stools.map { $0.rawValue }.joined(separator: ", "))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Bloating status
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "balloon.fill")
                    .foregroundStyle(.accent)
                
                Text("Bloating:")
                    .fontWeight(.semibold)
                
                Text((episodeToView.bloating ? "Yes" : "No"))
                    .foregroundStyle(.secondary)
            }
        }
        .fixedSize(horizontal: false, vertical: false)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
