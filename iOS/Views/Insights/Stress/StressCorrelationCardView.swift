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

    // State to keep track of our ViewModel object
    @State private var viewModel = StressCorrelationCardViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Label("Stress vs Symptoms", systemImage: "brain.head.profile")
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
                        LineMark(
                            x: .value("Stress", 1.0),
                            y: .value(viewModel.selectedSymptom.rawValue, trend.slope * 1 + trend.intercept)
                        )
                        LineMark(
                            x: .value("Stress", 10.0),
                            y: .value(viewModel.selectedSymptom.rawValue, trend.slope * 10 + trend.intercept)
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
