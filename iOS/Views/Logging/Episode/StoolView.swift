//
//  StoolView.swift
//
//  This view displays stool-related questions in the episode logging flow.
//
import SwiftUI

// Display a list of recent stool types
struct StoolView: View {
    // Take in the original EpisodeInput to mutate it
    @Binding var input: EpisodeInput
    
    // Pass in bindings to mutate state of episode in this view
    @Binding var stoolConsistency: Double
    @Binding var stoolUrgency: Double
    @Binding var stoolEffort: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "toilet.fill")
                        .foregroundStyle(.accent)
                    
                    Text("How solid was your stool?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                Slider(value: $stoolConsistency, in: 1...10, step: 0.15)
                    .tint(.accent)
                
                HStack {
                    Text("Consistency")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(stoolConsistency, specifier: "%.0f") / 10")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "toilet.fill")
                        .foregroundStyle(.accent)
                    
                    Text("How urgent was your bowel movement?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                Slider(value: $stoolUrgency, in: 1...10, step: 0.15)
                    .tint(.accent)
                
                HStack {
                    Text("Urgency")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(stoolUrgency, specifier: "%.0f") / 10")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "toilet.fill")
                        .foregroundStyle(.accent)
                    
                    Text("How hard was it to pass your stool?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                Slider(value: $stoolEffort, in: 1...10, step: 0.15)
                    .tint(.accent)
                
                HStack {
                    Text("Constipation")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(stoolEffort, specifier: "%.0f") / 10")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding()
    }
}
