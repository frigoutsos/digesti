//
//  WorstOffendersCardView.swift
//
//  Shows the single worst food for each symptom dimension —
//  intensity, consistency, urgency, effort, and bloating.
//
import SwiftUI

// A single worst-offender result for one symptom
private struct Offender {
    let food:       Food
    let value:      Double   // The average score for this symptom
    let isRate:     Bool     // true if value is a 0–1 rate (bloating), false if 1–10
}

struct WorstOffendersCardView: View {
    let episodes: [Episode]
    let meals:    [Meal]

    private var impacts: [FoodImpact] {
        computeFoodImpacts(episodes: episodes, meals: meals)
    }

    // Worst food per symptom (nil if no data)
    private var worstIntensity:    Offender? { worst(\.avgIntensity) }
    private var worstConsistency:  Offender? { worst(\.avgConsistency) }
    private var worstUrgency:      Offender? { worst(\.avgUrgency) }
    private var worstEffort:       Offender? { worst(\.avgEffort) }
    private var worstBloating:     Offender? { worstRate(\.bloatingRate) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Label("Worst Offenders", systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("The food most associated with each symptom, based on meals within 48h before episodes.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            if impacts.isEmpty {
                Text("Not enough data yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 10) {
                    offenderRow(
                        icon:     "speedometer",
                        symptom:  "Intensity",
                        offender: worstIntensity
                    )
                    offenderRow(
                        icon:     "toilet.fill",
                        symptom:  "Consistency",
                        offender: worstConsistency
                    )
                    offenderRow(
                        icon:     "toilet.fill",
                        symptom:  "Urgency",
                        offender: worstUrgency
                    )
                    offenderRow(
                        icon:     "toilet.fill",
                        symptom:  "Effort",
                        offender: worstEffort
                    )
                    offenderRow(
                        icon:     "balloon.fill",
                        symptom:  "Bloating",
                        offender: worstBloating
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }


    // MARK: - Sub-views

    @ViewBuilder
    private func offenderRow(icon: String, symptom: String, offender: Offender?) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.accent)
                .frame(width: 16, alignment: .center)

            Text(symptom)
                .fontWeight(.semibold)

            Spacer()

            if let o = offender {
                VStack(alignment: .trailing, spacing: 1) {
                    Text(o.food.name)
                        .foregroundStyle(.primary)

                    Text(o.isRate
                         ? String(format: "%.0f%% of episodes", o.value * 100)
                         : String(format: "avg %.1f / 10", o.value)
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            } else {
                Text("Not enough data")
                    .foregroundStyle(.secondary)
            }
        }
        .font(.subheadline)
    }


    // MARK: - Helpers

    // Returns the food with the highest average value for a numeric symptom
    private func worst(_ keyPath: KeyPath<FoodImpact, Double>) -> Offender? {
        guard let top = impacts.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] }) else {
            return nil
        }
        return Offender(food: top.food, value: top[keyPath: keyPath], isRate: false)
    }

    // Returns the food with the highest bloating rate
    private func worstRate(_ keyPath: KeyPath<FoodImpact, Double>) -> Offender? {
        guard let top = impacts.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] }),
              top[keyPath: keyPath] > 0 else { return nil }
        return Offender(food: top.food, value: top[keyPath: keyPath], isRate: true)
    }
}
