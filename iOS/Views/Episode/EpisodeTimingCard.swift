//
//  EpisodeTimingCard.swift
//
//  Card to group all the timing-related metrics entered by the user.
//
import SwiftUI

struct EpisodeTimingCard: View {
    let episodeToView: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Timing")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Onset info
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.secondary)
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
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Movement:")
                    .fontWeight(.semibold)
                
                Text(episodeToView.movement.formatted(date: .abbreviated, time: .shortened))
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
