//
//  TriggerFoodsCardView.swift
//
//  Ranks foods by a composite symptom impact score, only counting meals
//  eaten within 48 hours before each episode.
//
import SwiftUI

struct TriggerFoodsCardView: View {
    let episodes: [Episode]
    let meals:    [Meal]

    // Whether the detail rows are expanded
    @State private var expanded: Set<String> = []

    private var impacts: [FoodImpact] {
        computeFoodImpacts(episodes: episodes, meals: meals)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Label("Trigger Foods", systemImage: "fork.knife.circle.fill")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Foods eaten within 48h before an episode, ranked by symptom impact.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            if impacts.isEmpty {
                Text("Not enough data yet. Log meals before episodes to see trigger analysis.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(impacts.enumerated()), id: \.element.id) { index, impact in
                        foodRow(impact: impact, rank: index + 1)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }


    // MARK: - Sub-views

    @ViewBuilder
    private func foodRow(impact: FoodImpact, rank: Int) -> some View {
        let isExpanded = expanded.contains(impact.id)

        VStack(alignment: .leading, spacing: 6) {

            // Main row — tap to expand
            Button {
                if isExpanded {
                    expanded.remove(impact.id)
                } else {
                    expanded.insert(impact.id)
                }
            } label: {
                HStack(spacing: 10) {

                    // Rank badge
                    Text("\(rank)")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(rankColor(rank: rank))
                        .clipShape(Circle())

                    Text(impact.food.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    Spacer()

                    // Composite score pill
                    Text(String(format: "%.1f", impact.compositeScore))
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(scoreColor(impact.compositeScore).opacity(0.2))
                        .foregroundStyle(scoreColor(impact.compositeScore))
                        .clipShape(Capsule())

                    Text("\(impact.episodeCount) ep\(impact.episodeCount == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            // Expanded detail
            if isExpanded {
                VStack(spacing: 4) {
                    detailMetric(label: "Intensity",    value: impact.avgIntensity)
                    detailMetric(label: "Consistency",  value: impact.avgConsistency)
                    detailMetric(label: "Urgency",      value: impact.avgUrgency)
                    detailMetric(label: "Effort",       value: impact.avgEffort)

                    HStack {
                        Text("Bloating rate")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(String(format: "%.0f%%", impact.bloatingRate * 100))
                            .fontWeight(.semibold)
                    }
                    .font(.caption)
                }
                .padding(.leading, 34)
                .padding(.top, 2)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isExpanded)

        if rank < impacts.count {
            Divider().padding(.leading, 34)
        }
    }

    @ViewBuilder
    private func detailMetric(label: String, value: Double) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(String(format: "%.1f / 10", value))
                .fontWeight(.semibold)
        }
        .font(.caption)
    }


    // MARK: - Helpers

    private func rankColor(rank: Int) -> Color {
        switch rank {
        case 1:  return .red
        case 2:  return .orange
        case 3:  return .yellow
        default: return Color(.systemGray3)
        }
    }

    private func scoreColor(_ score: Double) -> Color {
        switch score {
        case 7...:  return .red
        case 5...:  return .orange
        case 3...:  return .yellow
        default:    return .green
        }
    }
}
