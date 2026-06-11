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
    
    // State to keep track of index for days with potentially multiple episodes
    @State private var currentIndex = 0
    
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
                VStack {
                    ScrollView {
                        EpisodeView(
                            episodeToView: viewModel.selectedDayEpisodes[currentIndex]
                        )
                    }
                    
                    // Navigation butons to navigate multiple episodes on a day
                    if (viewModel.selectedDayEpisodes.count > 1) {
                        HStack {
                            Button {
                                currentIndex -= 1
                            } label: {
                                Image(systemName: "chevron.backward")
                            }
                            .padding(.horizontal)
                            .buttonStyle(.bordered)
                            .disabled(currentIndex == 0)
                            
                            Spacer()
                            
                            Button {
                                currentIndex += 1
                            } label: {
                                Image(systemName: "chevron.forward")
                            }
                            .padding(.horizontal)
                            .buttonStyle(.bordered)
                            .disabled(currentIndex == viewModel.selectedDayEpisodes.count - 1)
                        }
                    }
                }
                .padding(.vertical)
                .navigationTitle("Episodes for \(viewModel.selectedDate.formatted(.dateTime.day().month()))")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.showInfo = false
                            currentIndex = 0
                            // Just have the view model store a really really old date that hopefully no one will ever need to press
                            viewModel.selectedDate = Date(timeIntervalSince1970: 0)
                            calendarID = UUID()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
