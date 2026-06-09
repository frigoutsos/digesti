//
//  BristolScaleListView.swift
//
//  View to create a list of stools on the Bristol scale.
//
import SwiftUI
import os

struct BristolScaleListView: View {
    var body: some View {
        // Hacky workaround to avoid padding watchOS
        #if os(watchOS)
        ScrollView {
            stackContent
        }
        
        #else
        ScrollView {
            stackContent
                .padding()
        }
        
        #endif
    }
    
    @ViewBuilder
    var stackContent: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Bristol Stool Scale")
                .font(.title2.bold())

            ForEach(BristolStoolType.allCases, id: \.self) { type in
                HStack(spacing: 16) {

                    // Visual stool
                    BristolStoolView(type: type)
                        .frame(width: 85, height: 50, alignment: .center)

                    VStack(alignment: .leading) {
                        Text(type.title)
                            .font(.headline)

                        Text(type.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.05))
                )
            }
        }
    }
}


#Preview {
    BristolScaleListView()
}
