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
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                    ForEach(Stool.allCases, id: \.self) { stool in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                // Toggle selection
                                if input.stools.contains(stool) {
                                    input.stools.removeAll { $0 == stool }
                                } else {
                                    input.stools.append(stool)
                                }
                            }
                        } label: {
                            Text(stool.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(input.stools.contains(stool) ? .black : .primary)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(input.stools.contains(stool) ? Color.accentColor : Color.accentColor.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .sensoryFeedback(.selection, trigger: input.stools.contains(stool))
                    }
                }
            }
        }
        .padding()
    }
}
