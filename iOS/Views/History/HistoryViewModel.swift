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
    
    // Store if we are filtering the list of episodes or not, and based on what filter
    var filter: EpisodeFilter = .all
    
    // Filter episodes based on search text (will not be filtered if search text is empty)
    func filteredEpisodes(from episodes: [Episode]) -> [Episode] {
        let typeFiltered = filterEpisodesByType(episodes)
        
        // Show all episodes if search is empty
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return typeFiltered }
        
        return typeFiltered.filter {
            $0.searchableText.lowercased().contains(searchText.lowercased())
        }
    }
    
    func filterEpisodesByType(_ episodes: [Episode]) -> [Episode] {
        switch filter {
        case .all:
            return episodes
        case .bloating:
            return episodes.filter {
                if case .bloating = $0 {
                    return true
                }
                
                return false
            }
        case .constipation:
            return episodes.filter {
                if case .constipation = $0 {
                    return true
                }
                
                return false
            }
        case .stool:
            return episodes.filter {
                if case .stool = $0 {
                    return true
                }
                
                return false
            }

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
