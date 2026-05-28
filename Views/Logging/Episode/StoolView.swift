//
//  StoolView.swift
//  ibsapp
//
//  Created by Franklin Rigoutsos on 5/2/26.
//
import SwiftUI

// Display a list of recent stool types
struct StoolView: View {
    // Take in the original EpisodeInput to mutate it
    @Binding var input: EpisodeInput
    // Pass in bindings to mutate state of episode in this view
    @Binding var stool_consistency: Double
    @Binding var stool_urgency: Double
    @Binding var stool_effort: Double

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
                
                Slider(value: $stool_consistency, in: 1...10, step: 0.15)
                    .tint(.accent)
                
                HStack {
                    Text("Consistency")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(stool_consistency, specifier: "%.0f") / 10")
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
                
                Slider(value: $stool_urgency, in: 1...10, step: 0.15)
                    .tint(.accent)
                
                HStack {
                    Text("Urgency")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(stool_urgency, specifier: "%.0f") / 10")
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
                
                Slider(value: $stool_effort, in: 1...10, step: 0.15)
                    .tint(.accent)
                
                HStack {
                    Text("Effort / Constipation")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(stool_effort, specifier: "%.0f") / 10")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding()
    }
}
