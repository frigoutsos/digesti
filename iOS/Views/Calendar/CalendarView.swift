//
//  CalendarView.swift
//
//  This view displays episodes on a calendar of the current month.
//
import SwiftUI
import SwiftData

struct CalendarView: View {
    // Get a list of episodes, reverse sorted by time
    @Query(sort: \Episode.onset, order: .reverse) private var episodes: [Episode]
    
    // State to keep track of our ViewModel object
    @State private var viewModel = CalendarViewModel()
    
    // Hacky state to allow re-selecting the current date
    @State private var calendarID = UUID()
    
    var body: some View {
        VStack(spacing: 0) {
            // Display our calendar
            CalendarUIKitView(
                selectedDate: $viewModel.selectedDate,
                episodeDays: viewModel.episodeDays,
            )
            .id(calendarID)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(.accent)
            .frame(maxWidth: 325)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            
            Divider()
            
            // Prompt the user to select a date on the calendar to see an episode card
            Text("Select a day to view an episode.")
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Calendar")
        .onAppear{
            viewModel.episodes = episodes
        }
        .onChange(of: episodes) {
            viewModel.episodes = episodes
        }
        .onChange(of: viewModel.selectedDate) {
            viewModel.updateSelectedDate(viewModel.selectedDate)
        }
        // If the user clicks on a date, pop up a sheet with an episode card
        .sheet(isPresented: $viewModel.showInfo) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        // Iterate through and display episodes for the selected day
                        ForEach(viewModel.selectedDayEpisodes) { episode in
                            EpisodeView(episodeToView: episode)
                                .padding()
                                .frame(maxWidth: 400)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.secondarySystemGroupedBackground))
                                        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                                )
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
                .navigationTitle("Episodes")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") {
                            viewModel.showInfo = false
                            // Just have the view model store a really really old date that hopefully no one will ever need to press
                            viewModel.selectedDate = Date(timeIntervalSince1970: 0)
                            calendarID = UUID()
                        }
                    }
                }
            }
        }
    }
}
