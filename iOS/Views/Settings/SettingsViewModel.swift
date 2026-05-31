//
//  SettingsViewModel.swift
//
//  ViewModel to hold computations related to the settings view.
//
import SwiftUI
import SwiftData

@Observable
class SettingsViewModel {
    // State to keep track of if the user is about to delete all app data
    var showDeleteConfirmation = false

    // Function to clear the app's data
    func clearAllData(modelContext: ModelContext) {
        do {
            let episodes = try modelContext.fetch(FetchDescriptor<Episode>())
            let meals = try modelContext.fetch(FetchDescriptor<Meal>())

            for episode in episodes { modelContext.delete(episode) }
            for meal in meals { modelContext.delete(meal) }

            try modelContext.save()
            print("All data cleared.")
            
            showDeleteConfirmation = false
        } catch {
            print("Failed to clear data: \(error)")
        }
    }
}
