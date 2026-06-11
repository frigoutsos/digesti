//
//  StressCorrelationCardViewModel.swift
//
//  ViewModel to handle stress card correlation-related calculations.
//
import SwiftUI

@Observable
class StressCorrelationCardViewModel {
    // Store the selected symptom we are looking at
    var selectedSymptom: StressSymptom = .intensity
    
    // Get the points from the data
    func getPoints(from episodes: [Episode]) -> [(stress: Double, symptom: Double)] {
        return episodes.map { (Double($0.stress), selectedSymptom.value(for: $0)) }
    }

    // Least-squares slope and intercept
    func getTrendline(from points: [(stress: Double, symptom: Double)]) -> (slope: Double, intercept: Double)? {
        let n = Double(points.count)
        guard n >= 2 else { return nil }
        let sx = points.map(\.stress).reduce(0, +)
        let sy = points.map(\.symptom).reduce(0, +)
        let sxy = points.map { $0.stress * $0.symptom }.reduce(0, +)
        let sx2 = points.map { $0.stress * $0.stress }.reduce(0, +)
        let denom = n * sx2 - sx * sx
        guard denom != 0 else { return nil }
        let slope = (n * sxy - sx * sy) / denom
        return (slope, (sy - slope * sx) / n)
    }

    // Pearson r
    func calcPearsonR(from points: [(stress: Double, symptom: Double)]) -> Double? {
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

    func getCorrelationLabel(from points: [(stress: Double, symptom: Double)]) -> String {
        guard let r = calcPearsonR(from: points) else { return "" }
        let symptom = selectedSymptom.rawValue.lowercased()
        let abs = Swift.abs(r)

        if r < 0 {
            switch abs {
            case ..<0.2: return "Stress doesn't appear to have any meaningful impact on your \(symptom)."
            case ..<0.4: return "Stress might not have a very large impact on your \(symptom)."
            case ..<0.6: return "Stress may actually help reduce your \(symptom) slightly."
            case ..<0.8: return "Interestingly, higher stress seems to correlate with lower \(symptom)."
            default: return "Higher stress strongly correlates with reduced \(symptom) — an unusual pattern worth discussing with your doctor."
            }
        } else {
            switch abs {
            case ..<0.2: return "Stress doesn't appear to have any meaningful impact on your \(symptom)."
            case ..<0.4: return "Stress may have a minor influence on your \(symptom)."
            case ..<0.6: return "Stress appears to moderately impact your \(symptom)."
            case ..<0.8: return "Stress seems to be a significant driver of your \(symptom)."
            default: return "Stress is very strongly associated with your \(symptom) — it looks like a major trigger."
            }
        }
    }
}

enum StressSymptom: String, CaseIterable, Identifiable {
    case intensity = "Intensity"
    case consistency = "Consistency"
    case urgency = "Urgency"
    case effort = "Effort"

    var id: Self { self }

    func value(for episode: Episode) -> Double {
        switch self {
        case .intensity: return Double(episode.intensity)
        case .consistency: return Double(episode.stoolConsistency)
        case .urgency: return Double(episode.stoolUrgency)
        case .effort: return Double(episode.stoolEffort)
        }
    }
}
