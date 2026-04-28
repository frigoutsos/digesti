//
//  LifetimeCardView.swift
//  ibs-app
//
//  This view creates a card to display a summary of lifetime episodes.
//
import SwiftUI

struct LifetimeCardView: View {
    // Pass the calculated values to display, rather than the entire list of episodes
    let episodeCount: Int
    let mostCommonLifetimeTrigger: Food?
    let mostCommonLifetimeStool: Stool?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Title and number of episodes
            Label("All Time", systemImage: "chart.bar.fill")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(episodeCount)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                // Proper pluralization for the word episodes
                Text("episode\(episodeCount == 1 ? "" : "s")")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                // Most common trigger
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.accent)
                    
                    Text("Most common trigger:")
                        .fontWeight(.semibold)
                    
                    Text(mostCommonLifetimeTrigger?.name ?? "Unknown")
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
                
                // Most common stool type
                HStack(spacing: 8) {
                    Image(systemName: "toilet.fill")
                        .foregroundStyle(.accent)
                    
                    Text("Most common stool type:")
                        .fontWeight(.semibold)
                    
                    Text(mostCommonLifetimeStool?.rawValue ?? "Unknown")
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
