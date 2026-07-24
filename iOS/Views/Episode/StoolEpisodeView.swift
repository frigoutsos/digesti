//
//  StoolEpisodeView.swift
//
//  Card to group all the stool-related metrics entered by the user.
//
import SwiftUI

struct StoolEpisodeView: View {
    let episodeToView: StoolEpisode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Movement info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Last Bowel Movement:")
                    .fontWeight(.semibold)
                
                Text(episodeToView.onset.formatted(date: .abbreviated, time: .shortened))
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            // MARK: - Stool urgency info
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
            
            // MARK: - Stool effort info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "figure.run")
                    .foregroundStyle(.secondary)
                    .frame(width: 16, alignment: .center)
                
                Text("Effort:")
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
            
            // MARK: - Stool consistency info
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
    }
}
