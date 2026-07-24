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
            let bloatingEpisodes = try modelContext.fetch(FetchDescriptor<BloatingEpisode>())
            let constipationEpisodes = try modelContext.fetch(FetchDescriptor<ConstipationEpisode>())
            let stoolEpisodes = try modelContext.fetch(FetchDescriptor<StoolEpisode>())
            let meals = try modelContext.fetch(FetchDescriptor<Meal>())

            for bloat in bloatingEpisodes { modelContext.delete(bloat) }
            for constip in bloatingEpisodes { modelContext.delete(constip) }
            for stool in bloatingEpisodes { modelContext.delete(stool) }
            
            for meal in meals { modelContext.delete(meal) }

            try modelContext.save()
            print("All data cleared.")
            
            showDeleteConfirmation = false
        } catch {
            print("Failed to clear data: \(error)")
        }
    }
}
