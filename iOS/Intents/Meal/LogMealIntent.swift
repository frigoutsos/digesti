//
//  LogMealIntent.swift
//
//  Holds intents to log a meal.
//
import AppIntents

struct LogMealIntent: AppIntent {
    // Title of our intent to display to the user
    static var title: LocalizedStringResource = "Log Meal"
    
    // Reveal intent to system
    static var isDiscoverable: Bool = true
    
    // Open app when run (for iOS 18 and below)
    static var openAppWhenRun: Bool = true
    
    // For iOS 26 and above, indicate that the supported intent mode is for the foreground only
    @available(iOS 26.0, *)
    static var supportedModes: IntentModes { .foreground }
    
    func perform() async throws -> some IntentResult {
        await MainActor.run {
            // Present the meal logger to the user when the intent is run
            NavigationManager.shared.presentMealLogger()
        }
        
        return .result()
    }
}
