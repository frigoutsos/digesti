//
//  DietaryInsightCardView.swift
//
import SwiftUI
import Charts

struct DietaryInsightCardView: View {
    let episodes: [Episode]
    let range: InsightsRange
    let healthKit = HealthKitService.shared

    enum DietaryMetric: String, CaseIterable, Identifiable {
        case calories  = "Calories"
        case carbs     = "Carbs"
        case fiber     = "Fiber"
        case fat       = "Fat"
        case protein   = "Protein"
        case caffeine  = "Caffeine"
        case sugar     = "Sugar"
        var id: Self { self }
    }

    @State private var samples:       [HealthKitService.DietarySample] = []
    @State private var selectedMetric: DietaryMetric = .calories
    @State private var isLoading      = true

    private func value(for sample: HealthKitService.DietarySample) -> Double {
        switch selectedMetric {
        case .calories: return sample.calories
        case .carbs:    return sample.carbs
        case .fiber:    return sample.fiber
        case .fat:      return sample.fat
        case .protein:  return sample.protein
        case .caffeine: return sample.caffeine * 1000  // convert g → mg for readability
        case .sugar:    return sample.sugar
        }
    }

    private var unit: String {
        selectedMetric == .calories ? "kcal" : selectedMetric == .caffeine ? "mg" : "g"
    }

    private var pairs: [HealthEpisodePair] {
        let cal = Calendar.current
        var result: [HealthEpisodePair] = []
        for episode in episodes {
            let onsetDay = cal.startOfDay(for: episode.onset)
            let candidate = samples.filter { s in
                let sDay = cal.startOfDay(for: s.date)
                return sDay <= onsetDay &&
                       episode.onset.timeIntervalSince(s.date) <= 24 * 3600
            }.max(by: { $0.date < $1.date })
            if let s = candidate {
                result.append(HealthEpisodePair(episode: episode, healthValue: value(for: s)))
            }
        }
        return result
    }

    private var r: Double? { pearson(pairs: pairs, symptom: \.intensity) }

    var body: some View {
        insightCard(
            title:   "Dietary Data & Episodes",
            icon:    "fork.knife.circle.fill",
            caption: "Nutritional intake on episode days from Apple Health."
        ) {
            // Replace the Picker and its .pickerStyle modifier with this:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(DietaryMetric.allCases) { metric in
                        Button(metric.rawValue) {
                            selectedMetric = metric
                        }
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedMetric == metric
                            ? Color.accentColor
                            : Color(.systemGray5))
                        .foregroundStyle(selectedMetric == metric
                            ? Color.white
                            : Color.primary)
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 1)
            }
            .padding(.bottom, 4)

            if isLoading {
                ProgressView().frame(maxWidth: .infinity)
            } else if pairs.isEmpty {
                emptyState("No overlapping dietary data found. Verify that Health access is granted in Settings.")
            } else {
                Chart {
                    ForEach(Array(pairs.enumerated()), id: \.offset) { _, p in
                        PointMark(
                            x: .value(selectedMetric.rawValue, p.healthValue),
                            y: .value("Intensity", Double(p.episode.intensity))
                        )
                        .foregroundStyle(Color.orange.opacity(0.7))
                        .symbolSize(55)
                    }
                    if let trend = trendLine(pairs: pairs) {
                        LineMark(x: .value("d", trend.xMin), y: .value("i", trend.yAt(trend.xMin)))
                        LineMark(x: .value("d", trend.xMax), y: .value("i", trend.yAt(trend.xMax)))
                        .foregroundStyle(Color.red)
                        .lineStyle(StrokeStyle(dash: [5,4]))
                    }
                }
                .chartXAxisLabel("\(selectedMetric.rawValue) (\(unit))")
                .chartYAxisLabel("Intensity")
                .chartYScale(domain: 0...10)
                .frame(height: 200)

                if let r {
                    Text(correlationSummary(r: r, healthMetric: selectedMetric.rawValue.lowercased(), symptom: "intensity"))
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
        samples   = await healthKit.fetchDietary(from: start, to: Date())
        isLoading = false
    }
}
