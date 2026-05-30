//
//  StressCorrelationCardView.swift
//
//  Scatter plot of stress vs a chosen symptom metric,
//  with a least-squares trend line and Pearson r label.
//
import SwiftUI
import Charts

enum StressSymptom: String, CaseIterable, Identifiable {
    case intensity   = "Intensity"
    case consistency = "Consistency"
    case urgency     = "Urgency"
    case effort      = "Effort"

    var id: Self { self }

    func value(for episode: Episode) -> Double {
        switch self {
        case .intensity:   return Double(episode.intensity)
        case .consistency: return Double(episode.stoolConsistency)
        case .urgency:     return Double(episode.stoolUrgency)
        case .effort:      return Double(episode.stoolEffort)
        }
    }
}

struct StressCorrelationCardView: View {
    let episodes: [Episode]

    @State private var selectedSymptom: StressSymptom = .intensity

    private var points: [(stress: Double, symptom: Double)] {
        episodes.map { (Double($0.stress), selectedSymptom.value(for: $0)) }
    }

    // Least-squares slope and intercept
    private var trendLine: (slope: Double, intercept: Double)? {
        let n = Double(points.count)
        guard n >= 2 else { return nil }
        let sx  = points.map(\.stress).reduce(0, +)
        let sy  = points.map(\.symptom).reduce(0, +)
        let sxy = points.map { $0.stress * $0.symptom }.reduce(0, +)
        let sx2 = points.map { $0.stress * $0.stress }.reduce(0, +)
        let denom = n * sx2 - sx * sx
        guard denom != 0 else { return nil }
        let slope = (n * sxy - sx * sy) / denom
        return (slope, (sy - slope * sx) / n)
    }

    // Pearson r
    private var pearsonR: Double? {
        let n = Double(points.count)
        guard n >= 2 else { return nil }
        let mx = points.map(\.stress).reduce(0, +) / n
        let my = points.map(\.symptom).reduce(0, +) / n
        var num = 0.0, dx2 = 0.0, dy2 = 0.0
        for p in points {
            num += (p.stress - mx) * (p.symptom - my)
            dx2 += (p.stress - mx) * (p.stress - mx)
            dy2 += (p.symptom - my) * (p.symptom - my)
        }
        let denom = sqrt(dx2 * dy2)
        return denom == 0 ? nil : num / denom
    }

    private var correlationLabel: String {
        guard let r = pearsonR else { return "" }
        let symptom = selectedSymptom.rawValue.lowercased()
        let abs = Swift.abs(r)

        if r < 0 {
            switch abs {
            case ..<0.2: return "Stress doesn't appear to have any meaningful impact on your \(symptom)."
            case ..<0.4: return "Stress might not have a very large impact on your \(symptom)."
            case ..<0.6: return "Stress may actually help reduce your \(symptom) slightly."
            case ..<0.8: return "Interestingly, higher stress seems to correlate with lower \(symptom)."
            default:     return "Higher stress strongly correlates with reduced \(symptom) — an unusual pattern worth discussing with your doctor."
            }
        } else {
            switch abs {
            case ..<0.2: return "Stress doesn't appear to have any meaningful impact on your \(symptom)."
            case ..<0.4: return "Stress may have a minor influence on your \(symptom)."
            case ..<0.6: return "Stress appears to moderately impact your \(symptom)."
            case ..<0.8: return "Stress seems to be a significant driver of your \(symptom)."
            default:     return "Stress is very strongly associated with your \(symptom) — it looks like a major trigger."
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Label("Stress vs Symptoms", systemImage: "brain.head.profile")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Each dot is one episode. The trend line shows the overall relationship.")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Symptom picker
            Picker("Symptom", selection: $selectedSymptom) {
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
                    ForEach(Array(points.enumerated()), id: \.offset) { _, p in
                        PointMark(
                            x: .value("Stress", p.stress),
                            y: .value(selectedSymptom.rawValue, p.symptom)
                        )
                        .foregroundStyle(Color.blue.opacity(0.7))
                        .symbolSize(60)
                    }

                    // Trend line
                    if let trend = trendLine {
                        LineMark(
                            x: .value("Stress", 1.0),
                            y: .value(selectedSymptom.rawValue, trend.slope * 1 + trend.intercept)
                        )
                        LineMark(
                            x: .value("Stress", 10.0),
                            y: .value(selectedSymptom.rawValue, trend.slope * 10 + trend.intercept)
                        )
                    }
                }
                .chartXScale(domain: 0.5...10.5)
                .chartYScale(domain: 0.5...10.5)
                .chartXAxisLabel("Stress (1–10)")
                .chartYAxisLabel(selectedSymptom.rawValue)
                .frame(height: 220)

                // Correlation summary
                if !correlationLabel.isEmpty {
                    Text(correlationLabel)
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
