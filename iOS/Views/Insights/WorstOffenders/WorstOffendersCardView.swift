//
//  WorstOffendersCardView.swift
//
//  Shows the single worst food for each symptom dimension —
//  intensity, consistency, urgency, effort, and bloating.
//
import SwiftUI

struct WorstOffendersCardView: View {
    // Take in a list of episodes
    let episodes: [Episode]
    
    // Take in a list of meals
    let meals: [Meal]
    
    // State to keep track of our ViewModel object
    @State private var viewModel = WorstOffendersCardViewModel()

    // Worst food per symptom (nil if no data)
    private var impacts: [FoodImpact] { viewModel.impacts(episodes: episodes, meals: meals) }

    private var worstIntensity: Offender? { viewModel.worst(\.avgIntensity, from: impacts) }

    private var worstConsistency: Offender? { viewModel.worst(\.avgConsistency, from: impacts) }

    private var worstUrgency: Offender? { viewModel.worst(\.avgUrgency, from: impacts) }

    private var worstEffort: Offender? { viewModel.worst(\.avgEffort, from: impacts) }

    private var worstBloating: Offender? { viewModel.worstRate(\.bloatingRate, from: impacts) }
    
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
}
