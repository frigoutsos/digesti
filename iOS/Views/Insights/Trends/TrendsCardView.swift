//
//  TrendsCardView.swift
//
//  Displays average symptom scores for the selected time window, with
//  trend arrows comparing to the previous equal window.
//
import SwiftUI

struct TrendsCardView: View {
    let currentEpisodes: [Episode]
    let previousEpisodes: [Episode]
    let range: InsightsRange

    private var current: SymptomAverages? { computeAverages(for: currentEpisodes) }
    private var previous: SymptomAverages? { computeAverages(for: previousEpisodes) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Label("Averages – \(range.rawValue)", systemImage: "chart.line.uptrend.xyaxis")
                .font(.headline)
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(currentEpisodes.count)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                Text("episode\(currentEpisodes.count == 1 ? "" : "s")")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Divider()

            if let avg = current {
                VStack(spacing: 10) {
                    metricRow(
                        icon: "speedometer",
                        label: "Average intensity",
                        value: avg.intensity,
                        prevVal: previous?.intensity
                    )
                    metricRow(
                        icon: "figure.mind.and.body",
                        label: "Average stress",
                        value: avg.stress,
                        prevVal: previous?.stress
                    )
                    metricRow(
                        icon: "toilet.fill",
                        label: "Average consistency",
                        value: avg.stoolConsistency,
                        prevVal: previous?.stoolConsistency
                    )
                    metricRow(
                        icon: "toilet.fill",
                        label: "Average urgency",
                        value: avg.stoolUrgency,
                        prevVal: previous?.stoolUrgency
                    )
                    metricRow(
                        icon: "toilet.fill",
                        label: "Average effort",
                        value: avg.stoolEffort,
                        prevVal: previous?.stoolEffort
                    )
                    bloatingRow(rate: avg.bloatingRate, prevRate: previous?.bloatingRate)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private func metricRow(
        icon: String,
        label: String,
        value: Double,
        prevVal: Double?
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.accent)
                .frame(width: 16, alignment: .center)

            Text(label)
                .fontWeight(.semibold)

            Spacer()

            Text(String(format: "%.1f / 10", value))
                .foregroundStyle(.secondary)

            if let prev = prevVal {
                trendArrow(current: value, previous: prev)
            }
        }
        .font(.subheadline)
    }

    @ViewBuilder
    private func bloatingRow(rate: Double, prevRate: Double?) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "balloon.fill")
                .foregroundStyle(.accent)
                .frame(width: 16, alignment: .center)

            Text("Bloating rate")
                .fontWeight(.semibold)

            Spacer()

            Text(String(format: "%.0f%%", rate * 100))
                .foregroundStyle(.secondary)

            if let prev = prevRate {
                trendArrow(current: rate, previous: prev, lowerIsBetter: true)
            }
        }
        .font(.subheadline)
    }

    // Arrow that indicates whether the metric improved or worsened.
    // By default, lower is better for symptom scores.
    @ViewBuilder
    private func trendArrow(
        current: Double,
        previous: Double,
        lowerIsBetter: Bool = true
    ) -> some View {
        let delta = current - previous
        let threshold = 0.25  // ignore tiny differences

        if abs(delta) < threshold {
            Image(systemName: "minus")
                .foregroundStyle(.secondary)
        } else {
            let improved = lowerIsBetter ? delta < 0 : delta > 0
            Image(systemName: delta < 0 ? "arrow.down" : "arrow.up")
                .foregroundStyle(improved ? .green : .red)
        }
    }
}
