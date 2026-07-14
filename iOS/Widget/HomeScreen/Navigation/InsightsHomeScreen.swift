//
//  InsightsHomeScreen.swift
//
//  Home screen widget to view insights.
//
import SwiftUI
import WidgetKit
import AppIntents

struct InsightsHomeScreenEntry: TimelineEntry {
    let date: Date
}

struct InsightsHomeScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> InsightsHomeScreenEntry {
        InsightsHomeScreenEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (InsightsHomeScreenEntry) -> Void) {
        completion(InsightsHomeScreenEntry(date: .now))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<InsightsHomeScreenEntry>) -> Void) {
        completion(Timeline(entries: [InsightsHomeScreenEntry(date: .now)],
                            policy: .never))
    }
}

struct InsightsHomeScreenEntryView: View {
    var body: some View {
        Button(intent: ViewInsightsIntent()) {
            VStack(alignment: .leading, spacing: 0) {
                Image(systemName: "lightbulb.fill")
                    .font(.title3)
                    .foregroundStyle(.accent)

                Spacer()

                Text("View Insights")
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

struct InsightsHomeScreenWidget: Widget {
    let kind: String = "dev.daemon.digesti.InsightsHomeScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: InsightsHomeScreenProvider()) { entry in
            InsightsHomeScreenEntryView()
        }
        .configurationDisplayName("View Insights")
        .description("Quickly view insights from your home screen.")
        .supportedFamilies([.systemSmall])
    }
}

