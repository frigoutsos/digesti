//
//  HomeView.swift
//  AheadAche
//
//  This view holds the app's home screen.
//
//  Created by Franklin Rigoutsos on 1/20/26.
//
import SwiftUI

struct HomeView: View {
    // State to track if the user clicked the "Log Headache" button
    @State private var showLogger = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                
                // Homepage welcome
                VStack(spacing: 12) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 48))
                        .foregroundStyle(.blue)
                    
                    Text("Track Your Headaches")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Log episodes and uncover patterns.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button {
                    showLogger = true
                } label: {
                    Label("Log Headache", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .padding(.horizontal)
                // Direct the user to the logging view after clicking the log button
                .sheet(isPresented: $showLogger) {
                    LoggingView()
                }
                
                Spacer()
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
