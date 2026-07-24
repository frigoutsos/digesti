
//  HealthKitInsightHelpers.swift
//
//  Pairs HealthKit daily samples to episodes and computes
//  Pearson r between a health metric and a symptom score.
//
import Foundation

// A paired data point: one episode + the health value on the preceding day
struct HealthEpisodePair {
    let episode:     Episode
    let healthValue: Double
}

// Pair each episode with the health sample from the night/day before onset
func pairSamples<T>(
    episodes: [Episode],
    samples:  [T],
    date:     KeyPath<T, Date>,
    value:    KeyPath<T, Double>,
    windowHours: Double = 24   // how far before onset to look
) -> [HealthEpisodePair] {
    var pairs: [HealthEpisodePair] = []
    let window = windowHours * 3600
    let cal    = Calendar.current

    for episode in episodes {
        let onsetDay = cal.startOfDay(for: episode.onset)
        // Find the sample whose day is closest before onset
        let candidate = samples.filter { s in
            let sDay = cal.startOfDay(for: s[keyPath: date])
            return sDay <= onsetDay &&
                   episode.onset.timeIntervalSince(s[keyPath: date]) <= window
        }.max(by: { $0[keyPath: date] < $1[keyPath: date] })

        if let s = candidate {
            pairs.append(HealthEpisodePair(episode: episode, healthValue: s[keyPath: value]))
        }
    }
    return pairs
}

// Pearson r between health values and a symptom score
func pearson(pairs: [HealthEpisodePair], symptom: KeyPath<Episode, Int>) -> Double? {
    guard pairs.count >= 3 else { return nil }
    let xs = pairs.map { $0.healthValue }
    let ys = pairs.map { Double($0.episode[keyPath: symptom]) }
    let n  = Double(pairs.count)
    let mx = xs.reduce(0,+) / n
    let my = ys.reduce(0,+) / n
    var num = 0.0, dx2 = 0.0, dy2 = 0.0
    for (x, y) in zip(xs, ys) {
        num += (x - mx) * (y - my)
        dx2 += (x - mx) * (x - mx)
        dy2 += (y - my) * (y - my)
    }
    let denom = sqrt(dx2 * dy2)
    return denom == 0 ? nil : num / denom
}

// Human-readable correlation summary
func correlationSummary(r: Double, healthMetric: String, symptom: String) -> String {
    let abs = Swift.abs(r)
    if abs < 0.2 {
        return "\(healthMetric) doesn't appear to have any meaningful relationship with your \(symptom)."
    }
    if r > 0 {
        switch abs {
        case ..<0.4: return "Higher \(healthMetric) may have a minor influence on your \(symptom)."
        case ..<0.6: return "Higher \(healthMetric) appears to moderately increase your \(symptom)."
        case ..<0.8: return "Higher \(healthMetric) seems to be a significant driver of your \(symptom)."
        default:     return "Higher \(healthMetric) is very strongly associated with worse \(symptom)."
        }
    } else {
        switch abs {
        case ..<0.4: return "Higher \(healthMetric) may slightly reduce your \(symptom)."
        case ..<0.6: return "Higher \(healthMetric) appears to moderately reduce your \(symptom)."
        case ..<0.8: return "Higher \(healthMetric) seems to noticeably reduce your \(symptom)."
        default:     return "Higher \(healthMetric) is very strongly associated with reduced \(symptom)."
        }
    }
}
