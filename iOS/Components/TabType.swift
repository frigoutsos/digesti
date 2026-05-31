//
//  TabType.swift
//
//  Contains an enum to represent the possible tab types in the application
//
enum TabType: Identifiable {
    case home
    case calendar
    case history
    case insights
    case settings
    
    var id: String {
        switch self {
        case .home: return "Home"
        case .calendar: return "Calendar"
        case .history: return "History"
        case .insights: return "Insights"
        case .settings: return "Settings"
        }
    }
}
