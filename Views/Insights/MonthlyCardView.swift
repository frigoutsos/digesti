//
//  MonthlyCardView.swift
//  AheadAche
//
//  This view creates a card to display a summary of monthly headaches.
//
//  Created by Franklin Rigoutsos on 2/17/26.
//
import SwiftUI

struct MonthlyCardView: View {
    // Pass the calculated values to display, rather than the entire list of headaches
    let headacheCount: Int
    let mostCommonMonthTrigger: HeadacheTrigger?
    let mostCommonMonthLocation: HeadacheLocation?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Title and number of headaches
            Label("Past 30 Days", systemImage: "calendar")
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
                    
                    Text(mostCommonMonthLocation?.rawValue ?? "Unknown")
                        .foregroundStyle(.primary)
                }
                .font(.subheadline)
            
                // Most common trigger
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                    
                    Text("Most common trigger:")
                        .fontWeight(.semibold)
                    
                    Text(mostCommonMonthTrigger?.rawValue ?? "Unknown")
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
