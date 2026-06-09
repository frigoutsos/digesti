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
                Image(systemName: "drop.fill")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Consistency:")
                    .fontWeight(.semibold)
                
                Text("\(episodeToView.stoolConsistency) / 10")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(episodeToView.bristolType.description)")
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
                
                Text("\(episodeToView.stoolUrgency) / 10")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            ProgressView(value: (Double(episodeToView.stoolUrgency) / 10.0))
                .padding(.horizontal)
                .tint(getColor(for: episodeToView.stoolUrgency))
            
            // Stool effort info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "figure.highintensity.intervaltraining")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Constipation:")
                    .fontWeight(.semibold)
                
                Text("\(episodeToView.stoolEffort) / 10")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            ProgressView(value: (Double(episodeToView.stoolEffort) / 10.0))
                .padding(.horizontal)
                .tint(getColor(for: episodeToView.stoolEffort))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
