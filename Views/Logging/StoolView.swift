//
//  StoolView.swift
//  ibs-app
//
//  Created by Franklin Rigoutsos on 5/2/26.
//
import SwiftUI

// Display a list of recent stool types
struct StoolView: View {
    // Take in the original EpisodeInput to mutate it
    @Binding var input: EpisodeInput

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "toilet.fill")
                    .foregroundStyle(.accent)
                
                Text("How would you describe your stool?")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Stool.allCases, id: \.self) { stool in
                        CustomButton(text: stool.rawValue, isSelected: input.stools.contains(stool)) {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                // Toggle selection
                                if input.stools.contains(stool) {
                                    input.stools.removeAll { $0 == stool }
                                } else {
                                    input.stools.append(stool)
                                }
                            }
                        }
                        .sensoryFeedback(.selection, trigger: input.stools.contains(stool))
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
}
