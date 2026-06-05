//
//  NavigationManager.swift
//
//  Manager to handle in-app navigation.
//
import SwiftUI

@Observable
class NavigationManager {
    static let shared = NavigationManager()
    // Control which tab we are displaying
    var selectedTab: TabType = .home
    
    // Used to present logger sheet or choose picker
    var activeSheet: SheetType? = nil
    
    // Control which history to display in the history tab
    var activeHistory: HistoryType? = .episode
    
    // Used by LogEpisodeIntent
    func presentEpisodeLogger() {
        selectedTab = .home
        activeSheet = .episode
    }
    
    // Used by LogMealIntent
    func presentMealLogger() {
        selectedTab = .home
        activeSheet = .meal
    }
    
    // Used by ViewEpisodeHistoryIntent
    func viewEpisodeHistory() {
        selectedTab = .history
        activeHistory = .episode
        activeSheet = nil
    }
    
    // Used by ViewMealHistoryIntent
    func viewMealHistory() {
        selectedTab = .history
        activeHistory = .meal
        activeSheet = nil
    }
    
    // Used by ViewInsightsIntent
    func viewInsights() {
        selectedTab = .insights
        activeSheet = nil
    }
    
    enum SheetType: Identifiable {
        case episode
        case meal
        
        var id: Int {
            switch self {
            case .episode: return 0
            case .meal: return 1
            }
        }
    }
    
    // enum for Episode or Meal history
    enum HistoryType: String, CaseIterable, Identifiable {
        case episode = "Episodes"
        case meal = "Meals"
        
        var id: Self { self }
    }
}
