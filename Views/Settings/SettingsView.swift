//
//  SettingsView.swift
//
//  View to contain settings for the application.
//
import SwiftUI
import SwiftData

struct SettingsView: View {
    // Access the configured model context
    @Environment(\.modelContext) private var modelContext

    // Store the user's preferred theme in the app storage
    @AppStorage("appTheme") private var appThemeRawValue: String = AppTheme.system.rawValue

    // State to keep track of if the user is about to delete all app data
    @State private var showDeleteConfirmation = false

    // Binding to hold the selected theme
    private var selectedThemeBinding: Binding<AppTheme> {
        Binding(
            get: { AppTheme(rawValue: appThemeRawValue) ?? .system },
            set: { appThemeRawValue = $0.rawValue }
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                // Theme selection buttom
                Section("Appearance") {
                    Picker("Theme", selection: selectedThemeBinding) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.displayName)
                                .tag(theme)
                        }
                    }
                }

                // Data management button
                Section("Data") {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Clear All Data", systemImage: "trash.fill")
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Delete All Data?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }

                Button("Delete", role: .destructive) {
                    clearAllData()
                }
            } message: {
                Text("This will permanently delete all Episode and Meal data.")
            }
        }
    }

    // Function to clear the app's data
    private func clearAllData() {
        do {
            try modelContext.delete(model: Episode.self)
            try modelContext.delete(model: Meal.self)

            try modelContext.save()

            print("All data cleared.")
        } catch {
            print("Failed to clear data: \(error)")
        }
    }
}
