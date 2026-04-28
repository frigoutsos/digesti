//
//  HomeView.swift
//  ibs-app
//
//  This view holds the app's home screen.
//
import SwiftUI

struct HomeView: View {
    // State to track if the user clicked the "Log Episode" button
    @State private var showLogger = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                
                // Homepage welcome
                VStack(spacing: 12) {
                    Image(systemName: "figure.mind.and.body")
                        .font(.system(size: 48))
                        .foregroundStyle(.accent)
                    
                    Text("Track Your IBS Episodes")
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
                    Label("Log Episode", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
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
