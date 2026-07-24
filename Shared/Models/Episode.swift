//
//  Episode.swift
//
//  This is the SwiftUI data model that represents all episode objects.
//
import SwiftUI
import SwiftData

@Model
final class BloatingEpisode {
    // Fields of a bloating episode
    var onset: Date
    var intensity: Int
    var stress: Int
    
    // Assign data to each field in the initializer
    init(
        onset: Date,
        intensity: Int,
        stress: Int
    ) {
        self.onset = onset
        self.intensity = intensity
        self.stress = stress
    }
}

@Model
final class ConstipationEpisode {
    // Fields of a constipation episode
    var onset: Date
    var stoolEffort: Int
    var stress: Int
    
    // Assign data to each field in the initializer
    init(
        onset: Date,
        stoolEffort: Int,
        stress: Int
    ) {
        self.onset = onset
        self.stoolEffort = stoolEffort
        self.stress = stress
    }
}

@Model
final class StoolEpisode {
    // Fields of a stool episode
    var onset: Date
    var stoolUrgency: Int
    var stoolEffort: Int
    var stoolConsistency: Int
    var stress: Int
    
    // Assign data to each field in the initializer
    init(
        onset: Date,
        stoolUrgency: Int,
        stoolEffort: Int,
        stoolConsistency: Int,
        stress: Int
    ) {
        self.onset = onset
        self.stoolUrgency = stoolUrgency
        self.stoolEffort = stoolEffort
        self.stoolConsistency = stoolConsistency
        self.stress = stress
    }
    
    // Extend episode using Bristol Stool Types
    var bristolType: BristolStoolType {
        .from(consistency: Double(stoolConsistency))
    }
}

// Display wrapper
enum Episode: Identifiable {
    case bloating(BloatingEpisode)
    case constipation(ConstipationEpisode)
    case stool(StoolEpisode)
    
    var id: PersistentIdentifier {
        switch self {
        case .bloating(let episode):
            return episode.persistentModelID
        case .constipation(let episode):
            return episode.persistentModelID
        case .stool(let episode):
            return episode.persistentModelID
        }
    }
    
    var onset: Date {
        switch self {
        case .bloating(let episode):
            return episode.onset
        case .constipation(let episode):
            return episode.onset
        case .stool(let episode):
            return episode.onset
        }
    }
    
    var title: String {
        switch self {
        case .bloating:
            return "Bloating Episode"
        case .constipation:
            return "Constipation Episode"
        case .stool:
            return "Stool Episode"
        }
    }
    
    var timingLabel: String {
        switch self {
        case .bloating:
            return "Onset"
        case .constipation, .stool:
            return "Bowel Movement"
        }
    }
    
    @ViewBuilder
    var rowPreview: some View {
        switch self {
        case .bloating(let episode):
            Text("Intensity: \(episode.intensity) / 5")
        case .constipation(let episode):
            Text("Effort: \(episode.stoolEffort) / 5")
        case .stool(let episode):
            Text("Stool Type: \(episode.stoolConsistency)")
        }
    }
    
    var searchableText: String {
        switch self {
        case .bloating(let episode):
            return [
                "\(episode.intensity)",
                "\(episode.stress)",
                "bloating",
                episode.onset.formatted(.dateTime.month(.wide).day())
            ]
            .joined(separator: " ")

        case .constipation(let episode):
            return [
                "\(episode.stress)",
                "\(episode.stoolEffort)",
                episode.onset.formatted(.dateTime.month(.wide).day())
            ]
            .joined(separator: " ")

        case .stool(let episode):
            return [
                "\(episode.stress)",
                "\(episode.stoolConsistency)",
                "\(episode.stoolUrgency)",
                "\(episode.stoolEffort)",
                episode.onset.formatted(.dateTime.month(.wide).day())
            ]
            .joined(separator: " ")
        }
    }

    func delete(from context: ModelContext) {
        switch self{
        case .bloating(let episode):
            context.delete(episode)
        case .constipation(let episode):
            context.delete(episode)
        case .stool(let episode):
            context.delete(episode)
        }
    }
}

enum EpisodeType {
    case stool
    case constipation
    case bloating
    
    var loggingSteps: [LoggingStep] { [] }
    
    func next(from step: LoggingStep) -> LoggingStep? {
        guard let position = loggingSteps.firstIndex(of: step),
              position + 1 < loggingSteps.count else { return nil }
        
        return loggingSteps[position + 1]
    }
    
    func prev(from step: LoggingStep) -> LoggingStep? {
        guard let position = loggingSteps.firstIndex(of: step),
                position - 1 >= 0 else { return nil }
        
        return loggingSteps[position - 1]
    }
}

enum EpisodeBuilder {
    static func build(from input: EpisodeInput, type: EpisodeType) -> any PersistentModel {
        switch type {
        case .stool:
            return StoolEpisode(
                onset: input.onset,
                stoolUrgency: input.stoolUrgency,
                stoolEffort: input.stoolEffort,
                stoolConsistency: input.stoolConsistency,
                stress: input.stress
            )
        case .constipation:
            return ConstipationEpisode(
                onset: input.onset,
                stoolEffort: input.stoolEffort,
                stress: input.stress
            )
        case .bloating:
            return BloatingEpisode(
                onset: input.onset,
                intensity: input.intensity,
                stress: input.stress
            )
        }
    }
}

enum LoggingStep: Int, CaseIterable {
    case onset
    case intensity
    case stress
    case bloating
    case stoolType
    case urgency
    case effort
    case summary
}

enum EpisodeFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case bloating = "Bloating"
    case constipation = "Constipation"
    case stool = "Stool"
    
    var id: String { rawValue }
}
