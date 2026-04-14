//
//  HeadacheView.swift
//  AheadAche
//
//  This view displays information about a selected headache in a compact way.
//
//  Created by Franklin Rigoutsos on 1/20/26.
//
import SwiftUI

struct HeadacheView: View {
    // Take in a Headache object to display in this view
    let headacheToView: Headache

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Date info
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundStyle(.blue)
                
                Text("Date:")
                    .fontWeight(.semibold)
                
                Text(headacheToView.onsetDateAndTime.formatted(date: .abbreviated, time: .shortened))
                    .foregroundStyle(.primary)
            }
            .font(.subheadline)
            
            // Intensity info
            HStack(spacing: 8) {
                Image(systemName: "speedometer")
                    .foregroundStyle(.red)
                
                Text("Intensity:")
                    .fontWeight(.semibold)
                
                Text("\(headacheToView.intensity) / 10")
                    .foregroundStyle(.primary)
            }
            .font(.subheadline)

            // Location(s) info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "location.fill")
                    .foregroundStyle(.orange)
                    .padding(.top, 2)

                Text("Locations:")
                    .fontWeight(.semibold)
                
                Text(headacheToView.locations.map { $0.rawValue }.joined(separator: ", "))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.primary)
            }
            .font(.subheadline)

            // Trigger(s) info
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.yellow)
                    .padding(.top, 2)
                
                Text("Triggers:")
                    .fontWeight(.semibold)
                
                Text(headacheToView.triggers.map { $0.rawValue }.joined(separator: ", "))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.primary)
            }
            .font(.subheadline)
        }
        .fixedSize(horizontal: false, vertical: false)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
