//
//  HistoryViewModel.swift
//
//  ViewModel to hold history-related calculations.
//
import SwiftUI

@Observable
class HistoryViewModel {
    // Track if we are showing info for the given date
    var showInfo: Bool = false
    
    // Store the current search text
    var searchText = ""
        
    // Store if we are presenting the user with an episode
    var selectedEpisode: Episode? = nil
    
    // Filter episodes based on search text (will not be filtered if search text is empty)
    func filteredEpisodes(from episodes: [Episode]) -> [Episode] {
        // Show all episodes if search is empty
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return episodes
        }
        
        let query = searchText.lowercased()
        
        return episodes.filter { episode in
            // Search intensity
            let intensityMatch = "\(episode.intensity)".contains(query)
            
            // Search stress level
            let stressMatch = "\(episode.stress)".contains(query)
            
            // Search bloating
            let bloatingMatch = episode.bloating && "bloating".contains(query)
            
            // Search onset date
            let onsetMatch = episode.onset.formatted(.dateTime.month(.wide).day())
                .lowercased()
                .contains(query)
            
            // Search movement date
            let movementMatch = episode.movement.formatted(.dateTime.month(.wide).day())
                .lowercased()
                .contains(query)
            
            // Search stool consistency
            let stoolConsistencyMatch = "\(episode.stoolConsistency)".contains(query)
            
            // Search stool urgency
            let stoolUrgencyMatch = "\(episode.stoolUrgency)".contains(query)
            
            // Search stool effort
            let stoolEffortMatch = "\(episode.stoolEffort)".contains(query)
            
            return intensityMatch
            || stressMatch
            || bloatingMatch
            || onsetMatch
            || movementMatch
            || stoolConsistencyMatch
            || stoolUrgencyMatch
            || stoolEffortMatch
        }
    }
    
    // Filter meals based on search text (will not be filtered if search text is empty)
    func filteredMeals(from meals: [Meal]) -> [Meal] {
        // Show all episodes if search is empty
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return meals
        }
        
        let query = searchText.lowercased()
        
        return meals.filter { meal in
            // Search meal date
            let dateMatch = meal.date.formatted(.dateTime.month(.wide).day())
                .lowercased()
                .contains(query)
                
            // Search foods
            let foodsMatch = meal.foods.contains { food in
                food.name
                    .lowercased()
                    .contains(query)
            }
            
            return dateMatch || foodsMatch
        }
    }
}
