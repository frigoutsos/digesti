//
//  InsightsView.swift
//  ibsapp
//
//  This view displays episode insights to the user.
//
import SwiftUI
import SwiftData

struct InsightsView: View {
    // Get a list of episodes, reverse sorted by time
    @Query(sort: \Episode.onset, order: .reverse) private var episodes: [Episode]
    
    // Get a list of meals, reverse sorted by time
    @Query(sort: \Meal.date, order: .reverse) private var meals: [Meal]
    
    // Computed property to get episodes last month
    private var episodesLastMonth: [Episode] {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        return episodes.filter { $0.onset >= oneMonthAgo }
    }
    
    // Computed property to get meals last month
    private var mealsLastMonth: [Meal] {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        return meals.filter { $0.date >= oneMonthAgo }
    }
    
    // Computed property for most common monthly food
    private var mostCommonMonthFood: Food? {
        // flatMap since the triggers field contains an array of triggers for each Meal object
        let foods = mealsLastMonth.flatMap { $0.foods }
        
        let counts = foods.reduce(into: [Food: Int]()) { counts, food in
            counts[food, default: 0] += 1
        }
        
        return counts.max(by: { $0.value < $1.value })?.key
    }

    // Computed property for most common monthly stool type
    /*
    private var mostCommonMonthStool: Stool? {
        // flatMap since the locations field contains an array of locations for each Episode object
        let stools = episodesLastMonth.flatMap { $0.stools }
        
        let counts = stools.reduce(into: [Stool: Int]()) { counts, stool in
            counts[stool, default: 0] += 1
        }
        
        return counts.max(by: { $0.value < $1.value })?.key
    }*/
    
    // Computed property for most common lifetime food
    private var mostCommonLifetimeFood: Food? {
        // flatMap since the triggers field contains an array of triggers for each Meal object
        let foods = meals.flatMap { $0.foods }
        
        // Create dictionary of counts
        let counts = foods.reduce(into: [Food: Int]()) { counts, food in
            counts[food, default: 0] += 1
        }
        
        // Find the key with the maximum count
        return counts.max(by: { $0.value < $1.value })?.key
    }
    
    // Computed property for most common lifetime episode location
    /*
    private var mostCommonLifetimeStool: Stool? {
        // flatMap since the locations field contains an array of locations for each episode object
        let stools = episodes.flatMap { $0.stools }
        
        let counts = stools.reduce(into: [Stool: Int]()) { counts, stool in
            counts[stool, default: 0] += 1
        }
        
        return counts.max(by: { $0.value < $1.value })?.key
    }*/
    
    var body: some View {
        // Make the view scrollable
        ScrollView {
            VStack(spacing: 20) {
                // Display the card views for episode insights
                MostRecentEpisodeView(mostRecentEpisode: episodes.first ?? nil)
                    .frame(maxWidth: 400)
                
                /*
                 * Rather than passing in the list of episodes to the card view to calculate frequencies,
                 * triggers, and locations, we do it here and pass the 3 results into the views.
                 */
                MonthlyCardView(episodeCount: episodesLastMonth.count,
                                mostCommonMonthFood: mostCommonMonthFood)
                                //mostCommonMonthStool: mostCommonMonthStool)
                    .frame(maxWidth: 400)
                
                LifetimeCardView(episodeCount: episodesLastMonth.count,
                                 mostCommonLifetimeFood: mostCommonLifetimeFood)
                                 //mostCommonLifetimeStool: mostCommonLifetimeStool)
                    .frame(maxWidth: 400)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .navigationTitle("Insights")
    }
}

#Preview {
    InsightsView()
}
