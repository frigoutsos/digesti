//
//  BloatingEpisodeView.swift
//
//  Card to group all the timing-related metrics entered by the user.
//
import SwiftUI

struct BloatingEpisodeView: View {
    let episodeToView: BloatingEpisode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Onset info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Onset:")
                    .fontWeight(.semibold)
                
                Text(episodeToView.onset.formatted(date: .abbreviated, time: .shortened))
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // MARK: - Intensity info
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
            
            // MARK: - Stress info
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
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.accent.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
