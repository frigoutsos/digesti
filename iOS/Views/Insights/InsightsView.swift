//
//  InsightsView.swift
//
//  This view displays episode insights to the user.
//
import SwiftUI
import SwiftData

struct InsightsView: View {
    // Get a list of episodes, reverse sorted by time
    @Query(sort: \BloatingEpisode.onset, order: .reverse) private var bloatingEpisodes: [BloatingEpisode]
    @Query(sort: \ConstipationEpisode.onset, order: .reverse) private var constipationEpisodes: [ConstipationEpisode]
    @Query(sort: \StoolEpisode.onset, order: .reverse) private var stoolEpisodes: [StoolEpisode]
    
    private var episodes: [Episode] {
        (
            bloatingEpisodes.map(Episode.bloating) +
            constipationEpisodes.map(Episode.constipation) +
            stoolEpisodes.map(Episode.stool)
        )
        .sorted { $0.onset > $1.onset }
    }
    
    // Get a list of meals, reverse sorted by time
    @Query(sort: \Meal.date, order: .reverse) private var meals: [Meal]

    // State to keep track of our ViewModel object
    @State private var viewModel = InsightsViewModel()
    
    // State to keep track of our HealthKit service object
    @ObservedObject var healthService = HealthKitService.shared
    
    // Store these as computed properties to avoid recalculating
    var filteredEpisodes: [Episode] { viewModel.episodesInRange(from: episodes) }
    var filteredMeals: [Meal] { viewModel.mealsInRange(from: meals) }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Time range picker
                Picker("Range", selection: $viewModel.selectedRange) {
                    ForEach(InsightsRange.allCases) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if viewModel.episodesInRange(from: episodes).isEmpty {
                    ContentUnavailableView(
                        "No Episodes",
                        systemImage: "chart.bar.xaxis",
                        description: Text("Log some episodes to see insights.")
                    )
                    .padding(.top, 40)
                } else {
                    // Trend averages card
                    TrendsCardView(
                        currentEpisodes: filteredEpisodes,
                        previousEpisodes: viewModel.episodesInPreviousRange(from: episodes),
                        range: viewModel.selectedRange)
                        .frame(maxWidth: 400)
                    
                    // Stress impact card
                    StressCorrelationCardView(
                        episodes: filteredEpisodes,
                        range: viewModel.selectedRange
                    )
                    .frame(maxWidth: 400)

                    // Trigger foods ranked by composite impact
                    TriggersCardView(episodes: filteredEpisodes, meals: filteredMeals)
                        .frame(maxWidth: 400)
                    
                    // Worst single offender per symptom
                    WorstOffendersCardView(episodes: filteredEpisodes, meals: filteredMeals)
                        .frame(maxWidth: 400)
                    
                    // Sleep insights
                    SleepInsightCardView(episodes: filteredEpisodes, range: viewModel.selectedRange)
                        .frame(maxWidth: 400)
                    
                    // Heart rate variability insights
                    HRVInsightCardView(episodes: filteredEpisodes, range: viewModel.selectedRange)
                        .frame(maxWidth: 400)
                    
                    // Activity insights
                    ActivityInsightCardView(episodes: filteredEpisodes, range: viewModel.selectedRange)
                        .frame(maxWidth: 400)
                    
                    // Dietary insights
                    DietaryInsightCardView(episodes: filteredEpisodes, range: viewModel.selectedRange)
                        .frame(maxWidth: 400)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .navigationTitle("Insights")
    }
}
