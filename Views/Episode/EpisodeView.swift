//
//  EpisodeView.swift
//
//  This file creates a view that displays information of an episode.
import SwiftUI

struct EpisodeView: View {
    // Take in an Episode object to display in this view
    let episodeToView: Episode

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Onset info
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.accent)
                    .frame(width: 16, alignment: .center)
                
                Text("Onset:")
                    .fontWeight(.semibold)
                
                Text(episodeToView.onset.formatted(date: .abbreviated, time: .shortened))
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Bowel movement info
            HStack(spacing: 8) {
                Image(systemName: "toilet.fill")
                    .foregroundStyle(.accent)
                    .frame(width: 16, alignment: .center)
                
                Text("Bowel movement:")
                    .fontWeight(.semibold)
                
                Text(episodeToView.movement.formatted(date: .abbreviated, time: .shortened))
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Intensity info
            HStack(spacing: 8) {
                Image(systemName: "speedometer")
                    .foregroundStyle(.accent)
                    .frame(width: 16, alignment: .center)
                
                Text("Intensity:")
                    .fontWeight(.semibold)
                
                Text("\(episodeToView.intensity) / 10")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Stool consistency info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "drop.fill")
                    .foregroundStyle(.accent)
                    .frame(width: 16, alignment: .center)

                Text("Stool consistency:")
                    .fontWeight(.semibold)
                
                Text("\(episodeToView.stoolConsistency) / 10")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Stool urgency info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.circle")
                    .foregroundStyle(.accent)
                    .frame(width: 16, alignment: .center)

                Text("Stool urgency:")
                    .fontWeight(.semibold)
                
                Text("\(episodeToView.stoolUrgency) / 10")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Stool effort info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "figure.highintensity.intervaltraining")
                    .foregroundStyle(.accent)
                    .frame(width: 16, alignment: .center)

                Text("Stool effort:")
                    .fontWeight(.semibold)
                
                Text("\(episodeToView.stoolEffort) / 10")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Bloating status
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "balloon.fill")
                    .foregroundStyle(.accent)
                    .frame(width: 16, alignment: .center)
                
                Text("Bloating:")
                    .fontWeight(.semibold)
                
                Text((episodeToView.bloating ? "Yes" : "No"))
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
        }
        .fixedSize(horizontal: false, vertical: false)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
