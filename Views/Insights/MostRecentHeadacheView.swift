//
//  MostRecentHeadacheView.swift
//  AheadAche
//
//  This view creates a card to display a summary of lifetime headaches.
//
//  Created by Franklin Rigoutsos on 2/17/26.
//
import SwiftUI

struct MostRecentHeadacheView: View {
    // The user may not have inputted any headaches yet, so make this input optional
    let mostRecentHeadache: Headache?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Title
            HStack(spacing: 8) {
                Label("Most Recent Headache", systemImage: "clock.arrow.circlepath")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                // If there is a headache to display, create a HeadacheView card
                if let headache = mostRecentHeadache {
                    HeadacheView(headacheToView: headache)
                // Otherwise, tell the user there are no headaches to display
                } else {
                    Text("No headaches to display.")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}
