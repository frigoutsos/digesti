//
//  EpisodeSymptomsCard.swift
//
//  Card to group all the miscellaneous metrics entered by the user.
//
import SwiftUI

struct EpisodeSymptomsCard: View {
    let episodeToView: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Symptoms")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Intensity info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "speedometer")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Intensity:")
                    .fontWeight(.semibold)
                
                Text(getEmoji(for: episodeToView.intensity))
            }
            .font(.subheadline)
            
            HStack(spacing: 8) {
                ProgressView(value: (Double(episodeToView.intensity) / 5.0))
                    .padding(.horizontal)
                    .tint(getColor(for: episodeToView.intensity))
                
                Spacer()
                
                Text("\(episodeToView.intensity)/5")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Intensity info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "figure.mind.and.body")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Stress:")
                    .fontWeight(.semibold)
                
                Text(getEmoji(for: episodeToView.stress))
            }
            .font(.subheadline)
            
            HStack(spacing: 8) {
                ProgressView(value: (Double(episodeToView.stress) / 5.0))
                    .padding(.horizontal)
                    .tint(getColor(for: episodeToView.stress))

                Spacer()
                
                Text("\(episodeToView.stress)/5")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // Bloating status
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "balloon.fill")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Bloating:")
                    .fontWeight(.semibold)
                
                Text((episodeToView.bloating ? "Yes" : "No"))
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
