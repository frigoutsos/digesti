//
//  MealHistoryHomeScreen.swift
//
//  Home screen widget to view meal history.
//
import SwiftUI
import WidgetKit
import AppIntents

struct MealHistoryHomeScreenEntry: TimelineEntry {
    let date: Date
}

struct MealHistoryHomeScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> MealHistoryHomeScreenEntry {
        MealHistoryHomeScreenEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MealHistoryHomeScreenEntry) -> Void) {
        completion(MealHistoryHomeScreenEntry(date: .now))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MealHistoryHomeScreenEntry>) -> Void) {
        completion(Timeline(entries: [MealHistoryHomeScreenEntry(date: .now)],
                            policy: .never))
    }
}

struct MealHistoryHomeScreenEntryView: View {
    var body: some View {
        Button(intent: ViewMealHistoryIntent()) {
            VStack(alignment: .leading, spacing: 0) {
                Image(systemName: "checkmark.arrow.trianglehead.counterclockwise")
                    .font(.title3)
                    .foregroundStyle(.accent)

                Spacer()

                Text("Meal History")
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

struct MealHistoryHomeScreenWidget: Widget {
    let kind: String = "dev.daemon.digesti.MealHistoryHomeScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MealHistoryHomeScreenProvider()) { entry in
            MealHistoryHomeScreenEntryView()
        }
        .configurationDisplayName("Meal History")
        .description("Quickly view meal history from your home screen.")
        .supportedFamilies([.systemSmall])
    }
}
