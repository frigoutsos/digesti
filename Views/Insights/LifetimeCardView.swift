//
//  LifetimeCardView.swift
//  AheadAche
//
//  This view creates a card to display a summary of lifetime headaches.
//
//  Created by Franklin Rigoutsos on 2/17/26.
//
import SwiftUI

struct LifetimeCardView: View {
    // Pass the calculated values to display, rather than the entire list of headaches
    let headacheCount: Int
    let mostCommonLifetimeTrigger: HeadacheTrigger?
    let mostCommonLifetimeLocation: HeadacheLocation?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Title and number of headaches
            Label("All Time", systemImage: "chart.bar.fill")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(headacheCount)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                // Proper pluralization for the word headaches
                Text("headache\(headacheCount == 1 ? "" : "s")")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                // Most common location
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .foregroundStyle(.orange)
                    
                    Text("Most common location:")
                        .fontWeight(.semibold)
                    
                    Text(mostCommonLifetimeLocation?.rawValue ?? "Unknown")
                        .foregroundStyle(.primary)
                }
                .font(.subheadline)
                
                // Most common trigger
                HStack(spacing: 8) {
                    Image(systemName: "bolt.heart.fill")
                        .foregroundStyle(.red)
                    
                    Text("Most common trigger:")
                        .fontWeight(.semibold)
                    
                    Text(mostCommonLifetimeTrigger?.rawValue ?? "Unknown")
                        .foregroundStyle(.primary)
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
