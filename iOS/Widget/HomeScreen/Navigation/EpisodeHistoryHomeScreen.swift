//
//  EpisodeHistoryHomeScreen.swift
//
//  Home screen widget to view episode history.
//
import SwiftUI
import WidgetKit
import AppIntents

struct EpisodeHistoryHomeScreenEntry: TimelineEntry {
    let date: Date
}

struct EpisodeHistoryHomeScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> EpisodeHistoryHomeScreenEntry {
        EpisodeHistoryHomeScreenEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (EpisodeHistoryHomeScreenEntry) -> Void) {
        completion(EpisodeHistoryHomeScreenEntry(date: .now))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<EpisodeHistoryHomeScreenEntry>) -> Void) {
        completion(Timeline(entries: [EpisodeHistoryHomeScreenEntry(date: .now)],
                            policy: .never))
    }
}

struct EpisodeHistoryHomeScreenEntryView: View {
    var body: some View {
        Button(intent: ViewEpisodeHistoryIntent()) {
            VStack(alignment: .leading, spacing: 0) {
                Image(systemName: "exclamationmark.arrow.trianglehead.counterclockwise.rotate.90")
                    .font(.title3)
                    .foregroundStyle(.accent)

                Spacer()

                Text("Episode History")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.accent)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

struct EpisodeHistoryHomeScreenWidget: Widget {
    let kind: String = "EpisodeHistoryHomeScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EpisodeHistoryHomeScreenProvider()) { entry in
            EpisodeHistoryHomeScreenEntryView()
        }
        .configurationDisplayName("Episode History")
        .description("Quickly view episode history from your home screen.")
        .supportedFamilies([.systemSmall])
    }
}
