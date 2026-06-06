//
//  InsightsView.swift
//
//  This view displays episode insights to the user.
//
import SwiftUI
import SwiftData

struct InsightsView: View {
    // Get a list of episodes, reverse sorted by time
    @Query(sort: \Episode.onset, order: .reverse) private var episodes: [Episode]
    
    // Get a list of meals, reverse sorted by time
    @Query(sort: \Meal.date, order: .reverse) private var meals: [Meal]

    // State to keep track of our ViewModel object
    @State private var viewModel = InsightsViewModel()
    
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
                        currentEpisodes: viewModel.episodesInRange(from: episodes),
                        previousEpisodes: viewModel.episodesInPreviousRange(from: episodes),
                        range: viewModel.selectedRange
                    )
                    .frame(maxWidth: 400)
                    
                    // Stress impact card
                    StressCorrelationCardView(episodes: viewModel.episodesInRange(from: episodes))
                        .frame(maxWidth: 400)

                    // Trigger foods ranked by composite impact
                    TriggersCardView(
                        episodes: viewModel.episodesInRange(from: episodes),
                        meals: viewModel.mealsInRange(from: meals)
                    )
                    .frame(maxWidth: 400)

                    // Worst single offender per symptom
                    WorstOffendersCardView(
                        episodes: viewModel.episodesInRange(from: episodes),
                        meals: viewModel.mealsInRange(from: meals)
                    )
                    .frame(maxWidth: 400)
                    
                    SleepInsightCardView(episodes: viewModel.episodesInRange(from: episodes))
                        .frame(maxWidth: 400)

                    HRVInsightCardView(episodes: viewModel.episodesInRange(from: episodes))
                        .frame(maxWidth: 400)

                    ActivityInsightCardView(episodes: viewModel.episodesInRange(from: episodes))
                        .frame(maxWidth: 400)

                    DietaryInsightCardView(episodes: viewModel.episodesInRange(from: episodes))
                        .frame(maxWidth: 400)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .navigationTitle("Insights")
    }
}
