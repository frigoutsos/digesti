//
//  EpisodeStoolCard.swift
//
//  Card to group all the stool-related metrics entered by the user.
//
import SwiftUI

struct EpisodeStoolCard: View {
    let episodeToView: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stool")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Stool consistency info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "toilet.fill")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Bristol Stool Type:")
                    .fontWeight(.semibold)
                
                Text("\(episodeToView.stoolConsistency) (\(episodeToView.bristolType.description))")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Stool urgency info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.circle")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Urgency:")
                    .fontWeight(.semibold)
                
                Text(getEmoji(for: episodeToView.stoolUrgency))
            }
            .font(.subheadline)
            
            HStack(spacing: 8) {
                ProgressView(value: (Double(episodeToView.stoolUrgency) / 5.0))
                    .padding(.horizontal)
                    .tint(getColor(for: episodeToView.stoolUrgency))
                
                Spacer()
                
                Text("\(episodeToView.stoolUrgency)/5")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Stool effort info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "figure.run")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Constipation:")
                    .fontWeight(.semibold)
                
                Text(getEmoji(for: episodeToView.stoolEffort))
            }
            .font(.subheadline)
            
            HStack(spacing: 8) {
                ProgressView(value: (Double(episodeToView.stoolEffort) / 5.0))
                    .padding(.horizontal)
                    .tint(getColor(for: episodeToView.stoolEffort))
                
                Spacer()
                
                Text("\(episodeToView.stoolEffort)/5")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
