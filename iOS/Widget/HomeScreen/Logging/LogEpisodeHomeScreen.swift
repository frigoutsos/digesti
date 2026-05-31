//
//  LogEpisodeHomeScreen.swift
//
//  Home screen widget to log an episode.
//
import SwiftUI
import WidgetKit
import AppIntents

struct LogEpisodeHomeScreenEntry: TimelineEntry {
    let date: Date
}

struct LogEpisodeHomeScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> LogEpisodeHomeScreenEntry {
        LogEpisodeHomeScreenEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LogEpisodeHomeScreenEntry) -> Void) {
        completion(LogEpisodeHomeScreenEntry(date: .now))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LogEpisodeHomeScreenEntry>) -> Void) {
        completion(Timeline(entries: [LogEpisodeHomeScreenEntry(date: .now)],
                            policy: .never))
    }
}

struct LogEpisodeHomeScreenEntryView: View {
    var body: some View {
        Button(intent: LogEpisodeIntent()) {
            VStack(alignment: .leading, spacing: 0) {
                Image(systemName: "bolt.fill")
                    .font(.title3)
                    .foregroundStyle(.accent)

                Spacer()

                Text("Log Episode")
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

struct LogEpisodeHomeScreenWidget: Widget {
    let kind: String = "LogEpisodeHomeScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LogEpisodeHomeScreenProvider()) { entry in
            LogEpisodeHomeScreenEntryView()
        }
        .configurationDisplayName("Log Episode")
        .description("Quickly log an episode from your home screen.")
        .supportedFamilies([.systemSmall])
    }
}
