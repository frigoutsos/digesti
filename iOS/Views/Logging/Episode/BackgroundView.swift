//
//  BackgroundView.swift
//
//  This view contains the background input steps
//
import SwiftUI

struct BackgroundView: View {
    // Pass in bindings to mutate state of episode in this view
    @Binding var onset: Date
    @Binding var movement: Date
    @Binding var intensity: Double
    @Binding var stress: Double
    @Binding var bloating: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.accent)
                    
                    Text("When did your episode start?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                    
                DatePicker("Onset",
                           selection: $onset,
                           in: ...Date(),
                           displayedComponents: [.date, .hourAndMinute])
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.accent)
                    
                    Text("When was your last bowel movement?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                DatePicker("Movement",
                           selection: $movement,
                           in: ...Date(),
                           displayedComponents: [.date, .hourAndMinute])
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "speedometer")
                        .foregroundStyle(.accent)
                    
                    Text("How intense is your episode?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                Slider(value: $intensity, in: 1...10, step: 0.15)
                    .tint(.accent)
                
                HStack {
                    Text("Intensity")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                 
                    Text("\(intensity, specifier: "%.0f") / 10")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "figure.mind.and.body")
                        .foregroundStyle(.accent)
                    
                    Text("How stressed are you?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                Slider(value: $stress, in: 1...10, step: 0.15)
                    .tint(.accent)
                
                HStack {
                    Text("Stress")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()
                    
                    Text("\(stress, specifier: "%.0f") / 10")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "balloon.fill")
                        .foregroundStyle(.accent)
                    
                    Toggle("Are you experiencing bloating?", isOn: $bloating)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding()
    }
}
