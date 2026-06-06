//
//  SleepInsightCardView.swift
//
import SwiftUI
import Charts

struct SleepInsightCardView: View {
    let episodes: [Episode]
    let range: InsightsRange
    let healthKit = HealthKitService.shared

    @State private var samples:   [HealthKitService.SleepSample] = []
    @State private var isLoading = true

    private var pairs: [HealthEpisodePair] {
        pairSamples(episodes: episodes, samples: samples,
                    date: \.date, value: \.hours)
    }

    private var r: Double? { pearson(pairs: pairs, symptom: \.intensity) }

    var body: some View {
        insightCard(
            title:   "Sleep & Episodes",
            icon:    "moon.zzz.fill",
            caption: "Hours of sleep the night before each episode."
        ) {
            if isLoading {
                ProgressView().frame(maxWidth: .infinity)
            } else if pairs.isEmpty {
                emptyState("No overlapping sleep data found.")
            } else {
                Chart {
                    ForEach(Array(pairs.enumerated()), id: \.offset) { _, p in
                        PointMark(
                            x: .value("Sleep (hrs)", p.healthValue),
                            y: .value("Intensity",   Double(p.episode.intensity))
                        )
                        .foregroundStyle(Color.blue.opacity(0.7))
                        .symbolSize(55)
                    }
                    if let r, let trend = trendLine(pairs: pairs) {
                        LineMark(x: .value("s", trend.xMin), y: .value("i", trend.yAt(trend.xMin)))
                        LineMark(x: .value("s", trend.xMax), y: .value("i", trend.yAt(trend.xMax)))
                        .foregroundStyle(Color.orange)
                        .lineStyle(StrokeStyle(dash: [5,4]))
                    }
                }
                .chartXAxisLabel("Sleep (hours)")
                .chartYAxisLabel("Intensity")
                .chartYScale(domain: 0...10)
                .frame(height: 200)

                if let r {
                    Text(correlationSummary(r: r, healthMetric: "sleep", symptom: "intensity"))
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
        samples   = await healthKit.fetchSleep(from: start, to: Date())
        isLoading = false
    }
}
