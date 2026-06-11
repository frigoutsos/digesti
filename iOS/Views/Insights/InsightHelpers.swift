//
//  InsightsHelpers.swift
//
//  Shared logic used across insight cards:
//    - Pairing meals to episodes within a 48-hour pre-episode window
//    - Computing per-food symptom impact scores
//
import SwiftUI
import Foundation

// Shared card wrapper for insights
@ViewBuilder
func insightCard<Content: View>(
    title:   String,
    icon:    String,
    caption: String,
    @ViewBuilder content: () -> Content
) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        Label(title, systemImage: icon)
            .font(.headline)
            .foregroundStyle(.secondary)
        
        Text(caption)
            .font(.caption)
            .foregroundStyle(.secondary)
        
        Divider()
        
        content()
    }
    .padding()
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: 16))
}

@ViewBuilder
func emptyState(_ message: String) -> some View {
    Text(message)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
}


// How far before an episode onset a meal can be to be considered a potential trigger
let kTriggerWindowSeconds: TimeInterval = 48 * 60 * 60  // 48 hours

// Symptom averages computed for a set of episodes
struct SymptomAverages {
    let intensity: Double
    let stress: Double
    let stoolConsistency: Double
    let stoolUrgency: Double
    let stoolEffort: Double
    let bloatingRate: Double  // 0.0 – 1.0 (proportion of episodes with bloating)
    let episodeCount: Int
}

// Per-food impact across all symptoms
struct FoodImpact: Identifiable {
    let food: Food
    let compositeScore: Double   // Higher = more associated with bad symptoms
    let avgIntensity: Double
    let avgConsistency: Double
    let avgUrgency: Double
    let avgEffort: Double
    let bloatingRate: Double   // 0.0 – 1.0
    let episodeCount: Int      // How many episodes this food appeared before

    // Food.id is a String, so use that directly
    var id: String { food.id }
}

// Returns all meals that occurred within 48 hours before the given episode onset
func linkedMeals(before episode: Episode, in allMeals: [Meal]) -> [Meal] {
    let onset = episode.onset
    return allMeals.filter { meal in
        meal.date <= onset && onset.timeIntervalSince(meal.date) <= kTriggerWindowSeconds
    }
}

// Returns a flat list of foods eaten within 48h before the given episode,
// de-duplicated per episode (so one food counts once per episode, not once per meal)
func triggerFoods(for episode: Episode, in allMeals: [Meal]) -> [Food] {
    let linkedMeals = linkedMeals(before: episode, in: allMeals)
    let allFoods = linkedMeals.flatMap { $0.foods }
    // De-duplicate by id so a food eaten twice before the same episode only counts once
    var seen = Set<String>()
    return allFoods.filter { seen.insert($0.id).inserted }
}

// Compute averages for a set of episodes
func computeAverages(for episodes: [Episode]) -> SymptomAverages? {
    guard !episodes.isEmpty else { return nil }
    let n = Double(episodes.count)
    return SymptomAverages(
        intensity: episodes.map { Double($0.intensity) }.reduce(0, +) / n,
        stress: episodes.map { Double($0.stress) }.reduce(0, +) / n,
        stoolConsistency: episodes.map { Double($0.stoolConsistency) }.reduce(0, +) / n,
        stoolUrgency: episodes.map { Double($0.stoolUrgency) }.reduce(0, +) / n,
        stoolEffort: episodes.map { Double($0.stoolEffort) }.reduce(0, +) / n,
        bloatingRate: Double(episodes.filter { $0.bloating }.count) / n,
        episodeCount: episodes.count
    )
}

// Build a ranked list of FoodImpact objects.
// Each food is scored by the average symptom severity of episodes it preceded.
// Only foods that appear before at least `minEpisodes` episodes are included.
func computeFoodImpacts(
    episodes: [Episode],
    meals allMeals: [Meal],
    minEpisodes: Int = 1
) -> [FoodImpact] {

    // Map each food id (String) → episodes it preceded
    var foodToEpisodes: [String: (food: Food, episodes: [Episode])] = [:]

    for episode in episodes {
        let foods = triggerFoods(for: episode, in: allMeals)
        for food in foods {
            if foodToEpisodes[food.id] == nil {
                foodToEpisodes[food.id] = (food, [])
            }
            foodToEpisodes[food.id]!.episodes.append(episode)
        }
    }

    var impacts: [FoodImpact] = []

    for (_, entry) in foodToEpisodes {
        guard entry.episodes.count >= minEpisodes else { continue }

        let eps = entry.episodes
        let n = Double(eps.count)

        let avgIntensity = eps.map { Double($0.intensity) }.reduce(0, +) / n
        let avgConsistency = eps.map { Double($0.stoolConsistency) }.reduce(0, +) / n
        let avgUrgency = eps.map { Double($0.stoolUrgency) }.reduce(0, +) / n
        let avgEffort = eps.map { Double($0.stoolEffort) }.reduce(0, +) / n
        let bloatingRate = Double(eps.filter { $0.bloating }.count) / n

        // Composite score: equal-weighted average of all symptom scores.
        // Bloating rate (0–1) is scaled to 0–10 to match the other metrics.
        let composite = (
            avgIntensity +
            avgConsistency +
            avgUrgency +
            avgEffort +
            bloatingRate * 10
        ) / 5.0

        impacts.append(FoodImpact(
            food:           entry.food,
            compositeScore: composite,
            avgIntensity:   avgIntensity,
            avgConsistency: avgConsistency,
            avgUrgency:     avgUrgency,
            avgEffort:      avgEffort,
            bloatingRate:   bloatingRate,
            episodeCount:   eps.count
        ))
    }

    // Sort by composite score descending
    return impacts.sorted { $0.compositeScore > $1.compositeScore }
}
