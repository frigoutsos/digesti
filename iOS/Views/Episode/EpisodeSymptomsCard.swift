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
            HStack(spacing: 8) {
                Image(systemName: "speedometer")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Intensity:")
                    .fontWeight(.semibold)
                
                Text("\(episodeToView.intensity) / 10")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            ProgressView(value: (Double(episodeToView.intensity) / 10.0))
                .padding(.horizontal)
                .tint(getColor(for: episodeToView.intensity))
            
            // Intensity info
            HStack(spacing: 8) {
                Image(systemName: "figure.mind.and.body")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Stress:")
                    .fontWeight(.semibold)
                
                Text("\(episodeToView.stress) / 10")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            ProgressView(value: (Double(episodeToView.stress) / 10.0))
                .padding(.horizontal)
                .tint(getColor(for: episodeToView.stress))
            
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
