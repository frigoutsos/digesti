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
    
    // State variables to handle showing episode info cards for selected dates
    @State private var selectedDate = Date()
    @State private var showInfo: Bool = false
    
    // Computed property to get set of Dates that had at least one episode logged on them
    private var episodeDays: Set<Date> {
        Set(episodes.map {
            Calendar.current.startOfDay(for: $0.onset)
        })
    }
    
    // Computed property to get the list of episodes for the selected date
    private var episodesForSelectedDay: [Episode] {
        let day = Calendar.current.startOfDay(for: selectedDate)
        return episodes.filter {
            Calendar.current.isDate($0.onset, inSameDayAs: day)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Display our calendar
            CalendarUIKitView(
                selectedDate: $selectedDate,
                episodeDays: episodeDays,
            )
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
        .onChange(of: selectedDate) {
            if (episodeDays.contains(selectedDate)) {
                showInfo = true
            }
        }
        // If the user clicks on a date, pop up a sheet with an episode card
        .sheet(isPresented: $showInfo) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        // Iterate through and display episodes for the selected day
                        ForEach(episodesForSelectedDay) { episode in
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
                            showInfo = false
                        }
                    }
                }
            }
        }
    }
}
