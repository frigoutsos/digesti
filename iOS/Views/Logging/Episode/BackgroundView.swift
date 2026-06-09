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
                    
                    Text("Symptom Onset:")
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
                    
                    Text("Last Bowel Movement:")
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
                    
                    Text("Intensity")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                Slider(value: $intensity, in: 1...10, step: 0.1)
                    .tint(getColor(for: intensity))
                    .onChange(of: intensity) {
                        print(intensity)
                    }
                
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
                    
                    Text("Stress Level:")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                Slider(value: $stress, in: 1...10, step: 0.1)
                    .tint(getColor(for: stress))
                
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
                    
                    Toggle("Bloating?", isOn: $bloating)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding()
    }
}
