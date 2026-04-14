//
//  CalendarView.swift
//  AheadAche
//
//  This view displays headaches on a calendar of the current month.
//
//  Created by Franklin Rigoutsos on 1/20/26.
//
import SwiftUI
import SwiftData

struct CalendarView: View {
    // Get a list of headaches, reverse sorted by time
    @Query(sort: \Headache.onsetDateAndTime, order: .reverse) private var headaches: [Headache]
    
    // State variables to handle showing headache info cards for selected dates
    @State private var selectedDate = Date()
    @State private var showInfo: Bool = false
    
    // Computed property to get set of Dates that had at least one headache logged on them
    private var headacheDays: Set<Date> {
        Set(headaches.map {
            Calendar.current.startOfDay(for: $0.onsetDateAndTime)
        })
    }
    
    // Computed property to get the list of headaches for the selected date
    private var headachesForSelectedDay: [Headache] {
        let day = Calendar.current.startOfDay(for: selectedDate)
        return headaches.filter {
            Calendar.current.isDate($0.onsetDateAndTime, inSameDayAs: day)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Display our calendar
            CalendarUIKitView(
                selectedDate: $selectedDate,
                headacheDays: headacheDays
            )
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: 325)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            
            Divider()
            
            // Prompt the user to select a date on the calendar to see a headache card
            Text("Select a day to view a headache.")
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Calendar")
        .onChange(of: selectedDate) {
            if (headacheDays.contains(selectedDate)) {
                showInfo = true
            }
        }
        // If the user clicks on a date, pop up a sheet with a headache card
        .sheet(isPresented: $showInfo) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        // Iterate through and display headaches for the selected day
                        ForEach(headachesForSelectedDay) { headache in
                            HeadacheView(headacheToView: headache)
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
                .navigationTitle("Headaches")
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

#Preview {
    CalendarView()
}
