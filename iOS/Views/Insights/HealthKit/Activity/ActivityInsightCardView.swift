//
//  ActivityInsightCardView.swift
//
import SwiftUI
import Charts

struct ActivityInsightCardView: View {
    let episodes: [Episode]
    let range: InsightsRange
    let healthKit = HealthKitService.shared

    @State private var samples:   [HealthKitService.ActivitySample] = []
    @State private var isLoading = true

    private var caloriePairs: [HealthEpisodePair] {
        pairSamples(episodes: episodes, samples: samples,
                    date: \.date, value: \.activeCalories)
    }

    private var r: Double? { pearson(pairs: caloriePairs, symptom: \.intensity) }

    var body: some View {
        insightCard(
            title:   "Activity & Episodes",
            icon:    "figure.run",
            caption: "Active calories burned on episode days."
        ) {
            if isLoading {
                ProgressView().frame(maxWidth: .infinity)
            } else if caloriePairs.isEmpty {
                emptyState("No overlapping activity data found.")
            } else {
                Chart {
                    ForEach(Array(caloriePairs.enumerated()), id: \.offset) { _, p in
                        PointMark(
                            x: .value("Calories", p.healthValue),
                            y: .value("Intensity", Double(p.episode.intensity))
                        )
                        .foregroundStyle(Color.green.opacity(0.7))
                        .symbolSize(55)
                    }
                    if let trend = trendLine(pairs: caloriePairs) {
                        LineMark(x: .value("c", trend.xMin), y: .value("i", trend.yAt(trend.xMin)))
                        LineMark(x: .value("c", trend.xMax), y: .value("i", trend.yAt(trend.xMax)))
                        .foregroundStyle(Color.orange)
                        .lineStyle(StrokeStyle(dash: [5,4]))
                    }
                }
                .chartXAxisLabel("Active calories (kcal)")
                .chartYAxisLabel("Intensity")
                .chartYScale(domain: 0...10)
                .frame(height: 200)

                if let r {
                    Text(correlationSummary(r: r, healthMetric: "activity", symptom: "intensity"))
                        .font(.caption).foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .task { await load() }
        .onChange(of: range) { _, _ in
            Task { await load() }
        }
    }

    private func load() async {
        let start = range.cutoff ?? Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        samples   = await healthKit.fetchActivity(from: start, to: Date())
        isLoading = false
    }
}
