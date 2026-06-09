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

    // State to keep track if the user wants the Bristol stool reference sheet
    @State private var presentStoolSheet: Bool = false

    // Binding to hold the selected theme
    private var selectedThemeBinding: Binding<AppTheme> {
        Binding(
            get: { AppTheme(rawValue: appThemeRawValue) ?? .system },
            set: { appThemeRawValue = $0.rawValue }
        )
    }
        
    // State to keep track of our ViewModel object
    @State private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                //
                Section("Information") {
                    Button {
                        presentStoolSheet = true
                    } label: {
                        Label("Bristol Stool Scale Reference Sheet", systemImage: "book.fill")
                    }
                    .sheet(isPresented: $presentStoolSheet) {
                        BristolScaleListView()
                    }
                }
                .foregroundStyle(.primary)
                
                // Theme selection button
                Section("Appearance") {
                    Picker(selection: selectedThemeBinding) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.displayName)
                                .tag(theme)
                        }
                    } label: {
                        Label("Theme", systemImage: "moon.fill")
                    }
                    .foregroundStyle(.primary)
                }

                // Data management button
                Section("Data") {
                    Button(role: .destructive) {
                        viewModel.showDeleteConfirmation = true
                    } label: {
                        Label("Clear All Data", systemImage: "trash.fill")
                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationTitle("Settings")
            .alert("Delete All Data?", isPresented: $viewModel.showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                    .foregroundStyle(.primary)

                Button("Delete", role: .destructive) {
                    viewModel.clearAllData(modelContext: modelContext)
                }
            } message: {
                Text("This will permanently delete all Episode and Meal data.")
            }
        }
    }
}
