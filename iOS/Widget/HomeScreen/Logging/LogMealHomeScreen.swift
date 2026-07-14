//
//  LogMealHomeScreen.swift
//
//  Home screen widget to log a meal.
//
import SwiftUI
import WidgetKit
import AppIntents

struct LogMealHomeScreenEntry: TimelineEntry {
    let date: Date
}

struct LogMealHomeScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> LogMealHomeScreenEntry {
        LogMealHomeScreenEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LogMealHomeScreenEntry) -> Void) {
        completion(LogMealHomeScreenEntry(date: .now))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LogMealHomeScreenEntry>) -> Void) {
        completion(Timeline(entries: [LogMealHomeScreenEntry(date: .now)],
                            policy: .never))
    }
}

struct LogMealHomeScreenEntryView: View {
    var body: some View {
        Button(intent: LogMealIntent()) {
            VStack(alignment: .leading, spacing: 0) {
                Image(systemName: "fork.knife")
                    .font(.title3)
                    .foregroundStyle(.accent)

                Spacer()

                Text("Log Meal")
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

struct LogMealHomeScreenWidget: Widget {
    let kind: String = "dev.daemon.digesti.LogMealHomeScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LogMealHomeScreenProvider()) { entry in
            LogMealHomeScreenEntryView()
        }
        .configurationDisplayName("Log meal")
        .description("Quickly log a meal from your home screen.")
        .supportedFamilies([.systemSmall])
    }
}
