//
//  StressCorrelationCardView.swift
//
//  Scatter plot of stress vs a chosen symptom metric, with a least-squares trend line and Pearson r label.
//
import SwiftUI
import Charts

struct StressCorrelationCardView: View {
    // Take in a list of episodes for which we display correlation statistics
    let episodes: [Episode]
    let range: InsightsRange

    // State to keep track of our ViewModel object
    @State private var viewModel = StressCorrelationCardViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Label("Stress vs Symptoms – \(range.rawValue)", systemImage: "brain.head.profile")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Each dot is one episode. The trend line shows the overall relationship.")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Symptom picker
            Picker("Symptom", selection: $viewModel.selectedSymptom) {
                ForEach(StressSymptom.allCases) { s in
                    Text(s.rawValue).tag(s)
                }
            }
            .pickerStyle(.segmented)

            Divider()

            if episodes.count < 3 {
                Text("Log at least 3 episodes to see the stress correlation chart.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            } else {
                Chart {
                    // Scatter points
                    ForEach(Array(viewModel.getPoints(from: episodes).enumerated()), id: \.offset) { _, p in
                        PointMark(
                            x: .value("Stress", p.stress),
                            y: .value(viewModel.selectedSymptom.rawValue, p.symptom)
                        )
                        .foregroundStyle(Color.blue.opacity(0.7))
                        .symbolSize(60)
                    }

                    // Trend line
                    if let trend = viewModel.getTrendline() {
                        let xMin = 1.0, xMax = 10.0
                        let yMin = max(0.5, trend.slope * xMin + trend.intercept)
                        let yMax = min(10.5, trend.slope * xMax + trend.intercept)
                        LineMark(
                            x: .value("Stress", xMin),
                            y: .value(viewModel.selectedSymptom.rawValue, yMin)
                        )
                        LineMark(
                            x: .value("Stress", xMax),
                            y: .value(viewModel.selectedSymptom.rawValue, yMax)
                        )
                    }
                }
                .chartXScale(domain: 0.5...10.5)
                .chartYScale(domain: 0.5...10.5)
                .chartXAxisLabel("Stress (1–10)")
                .chartYAxisLabel(viewModel.selectedSymptom.rawValue)
                .frame(height: 220)

                // Correlation summary
                if !viewModel.getCorrelationLabel().isEmpty {
                    Text(viewModel.getCorrelationLabel())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
