//
//  InsightsView.swift
//
//  This view displays episode insights to the user.
//
import SwiftUI
import SwiftData

// Time range options for the insights page
enum InsightsRange: String, CaseIterable, Identifiable {
    case thirtyDays  = "30d"
    case ninetyDays  = "90d"
    case allTime     = "All Time"

    var id: Self { self }

    // How far back to look, nil means no limit (all time)
    var cutoff: Date? {
        switch self {
        case .thirtyDays:  return Calendar.current.date(byAdding: .day,   value: -30, to: Date())
        case .ninetyDays:  return Calendar.current.date(byAdding: .day,   value: -90, to: Date())
        case .allTime:     return nil
        }
    }

    // The equivalent window before the current one, used for trend comparisons
    var previousCutoff: Date? {
        switch self {
        case .thirtyDays:  return Calendar.current.date(byAdding: .day,   value: -60, to: Date())
        case .ninetyDays:  return Calendar.current.date(byAdding: .day,   value: -180, to: Date())
        case .allTime:     return nil
        }
    }
}

struct InsightsView: View {
    // Get all episodes and meals sorted newest first
    @Query(sort: \Episode.onset, order: .reverse) private var allEpisodes: [Episode]
    @Query(sort: \Meal.date,    order: .reverse) private var allMeals:    [Meal]

    // Which time window the user has selected
    @State private var selectedRange: InsightsRange = .thirtyDays

    // Episodes that fall within the selected time window
    private var episodesInRange: [Episode] {
        guard let cutoff = selectedRange.cutoff else { return allEpisodes }
        return allEpisodes.filter { $0.onset >= cutoff }
    }

    // Episodes in the previous equal window, used for trend arrows
    private var episodesInPreviousRange: [Episode] {
        guard let cutoff = selectedRange.cutoff,
              let prevCutoff = selectedRange.previousCutoff else { return [] }
        return allEpisodes.filter { $0.onset >= prevCutoff && $0.onset < cutoff }
    }

    // Meals that fall within the selected time window
    private var mealsInRange: [Meal] {
        guard let cutoff = selectedRange.cutoff else { return allMeals }
        return allMeals.filter { $0.date >= cutoff }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Time range picker
                Picker("Range", selection: $selectedRange) {
                    ForEach(InsightsRange.allCases) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if episodesInRange.isEmpty {
                    ContentUnavailableView(
                        "No Episodes",
                        systemImage: "chart.bar.xaxis",
                        description: Text("Log some episodes to see insights.")
                    )
                    .padding(.top, 40)
                } else {

                    // Trend averages card
                    TrendCardView(
                        currentEpisodes:  episodesInRange,
                        previousEpisodes: episodesInPreviousRange,
                        range:            selectedRange
                    )
                    .frame(maxWidth: 400)
                    
                    // Stress impact card
                    StressCorrelationCardView(episodes: episodesInRange)
                        .frame(maxWidth: 400)

                    // Trigger foods ranked by composite impact
                    TriggerFoodsCardView(
                        episodes: episodesInRange,
                        meals:    mealsInRange
                    )
                    .frame(maxWidth: 400)

                    // Worst single offender per symptom
                    WorstOffendersCardView(
                        episodes: episodesInRange,
                        meals:    mealsInRange
                    )
                    .frame(maxWidth: 400)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .navigationTitle("Insights")
    }
}
