//
//  CalendarViewModel.swift
//
//  ViewModel to control calendar-related calculations.
//
import SwiftUI

@Observable
class CalendarViewModel {
    // Handle selected date
    var selectedDate = Date()
    
    // Track if we are showing info for the given date
    var showInfo: Bool = false
    
    // Store a list of episodes
    var episodes: [Episode] = []
    
    // Get set of dates that had at least one episode logged on them
    var episodeDays: Set<Date> {
        Set(episodes.map {
            Calendar.current.startOfDay(for: $0.onset)
        })
    }
    
    // Store list of episodes on a selected day
    var selectedDayEpisodes: [Episode] {
        episodes.filter {
            Calendar.current.isDate($0.onset, inSameDayAs: selectedDate)
        }
    }
    
    // Function to update the selected date
    func updateSelectedDate(_ date: Date) {
        selectedDate = date
        
        // Normalize selected date before checking
        if episodeDays.contains(Calendar.current.startOfDay(for: date)) {
            showInfo = true
        }
    }
}
