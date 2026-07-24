//
//  EpisodeTypeChooser.swift
//
//  View to choose which type of episode we want to log.
//
import SwiftUI

struct EpisodeTypeChooser: View {
    // Take in a binding of episode type
    @Binding var episodeType: EpisodeType?
    
    var body: some View {
        VStack {
            Text("What episode do you want to log?")
                .font(.title)
                .bold()
                .padding(.top, 48)
            
            ActionButton(title: "Bloating", icon: "balloon.fill") {
                episodeType = .bloating
            }
            
            ActionButton(title: "Constipation", icon: "figure.run") {
                episodeType = .constipation
            }
            
            ActionButton(title: "Stool", icon: "toilet.fill") {
                episodeType = .stool
            }
        }
    }
}
