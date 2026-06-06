//
//  HRVInsightCardView.swift
//
import SwiftUI
import Charts

struct HRVInsightCardView: View {
    let episodes: [Episode]
    let range: InsightsRange
    let healthKit = HealthKitService.shared

    @State private var samples:   [HealthKitService.HRVSample] = []
    @State private var isLoading = true

    private var pairs: [HealthEpisodePair] {
        pairSamples(episodes: episodes, samples: samples,
                    date: \.date, value: \.sdnn)
    }

    private var r: Double? { pearson(pairs: pairs, symptom: \.intensity) }

    var body: some View {
        insightCard(
            title:   "HRV & Episodes",
            icon:    "waveform.path.ecg",
            caption: "Heart rate variability (SDNN) on episode days. Lower HRV often reflects stress."
        ) {
            if isLoading {
                ProgressView().frame(maxWidth: .infinity)
            } else if pairs.isEmpty {
                emptyState("No overlapping HRV data found.")
            } else {
                Chart {
                    ForEach(Array(pairs.enumerated()), id: \.offset) { _, p in
                        PointMark(
                            x: .value("HRV (ms)", p.healthValue),
                            y: .value("Intensity", Double(p.episode.intensity))
                        )
                        .foregroundStyle(Color.purple.opacity(0.7))
                        .symbolSize(55)
                    }
                    if let trend = trendLine(pairs: pairs) {
                        LineMark(x: .value("h", trend.xMin), y: .value("i", trend.yAt(trend.xMin)))
                        LineMark(x: .value("h", trend.xMax), y: .value("i", trend.yAt(trend.xMax)))
                        .foregroundStyle(Color.orange)
                        .lineStyle(StrokeStyle(dash: [5,4]))
                    }
                }
                .chartXAxisLabel("HRV — SDNN (ms)")
                .chartYAxisLabel("Intensity")
                .chartYScale(domain: 0...10)
                .frame(height: 200)

                if let r {
                    Text(correlationSummary(r: r, healthMetric: "HRV", symptom: "intensity"))
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
        samples = await healthKit.fetchHRV(from: start, to: Date())
        isLoading = false
    }
}
