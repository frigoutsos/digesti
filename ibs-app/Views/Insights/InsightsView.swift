//
//  InsightsView.swift
//  AheadAche
//
//  This view displays headache insights to the user.
//
//  Created by Franklin Rigoutsos on 1/20/26.
//
import SwiftUI
import SwiftData

struct InsightsView: View {
    // Get a list of headaches, reverse sorted by time
    @Query(sort: \Headache.onsetDateAndTime, order: .reverse) private var headaches: [Headache]
    
    // Computed property to get headaches last month
    private var headachesLastMonth: [Headache] {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        return headaches.filter { $0.onsetDateAndTime >= oneMonthAgo }
    }
    
    // Computed property for most common monthly headache trigger
    private var mostCommonMonthTrigger: HeadacheTrigger? {
        // flatMap since the triggers field contains an array of triggers for each headache object
        let triggers = headachesLastMonth.flatMap { $0.triggers }
        
        let counts = triggers.reduce(into: [HeadacheTrigger: Int]()) { counts, trigger in
            counts[trigger, default: 0] += 1
        }
        
        return counts.max(by: { $0.value < $1.value })?.key
    }

    // Computed property for most common monthly headache location
    private var mostCommonMonthLocation: HeadacheLocation? {
        // flatMap since the locations field contains an array of locations for each headache object
        let locations = headachesLastMonth.flatMap { $0.locations }
        
        let counts = locations.reduce(into: [HeadacheLocation: Int]()) { counts, location in
            counts[location, default: 0] += 1
        }
        
        return counts.max(by: { $0.value < $1.value })?.key
    }
    
    // Computed property for most common lifetime headache trigger
    private var mostCommonLifetimeTrigger: HeadacheTrigger? {
        // flatMap since the triggers field contains an array of triggers for each headache object
        let triggers = headaches.flatMap { $0.triggers }
        
        // Create dictionary of counts
        let counts = triggers.reduce(into: [HeadacheTrigger: Int]()) { counts, trigger in
            counts[trigger, default: 0] += 1
        }
        
        // Find the key with the maximum count
        return counts.max(by: { $0.value < $1.value })?.key
    }
    
    // Computed property for most common lifetime headache location
    private var mostCommonLifetimeLocation: HeadacheLocation? {
        // flatMap since the locations field contains an array of locations for each headache object
        let locations = headaches.flatMap { $0.locations }
        
        let counts = locations.reduce(into: [HeadacheLocation: Int]()) { counts, location in
            counts[location, default: 0] += 1
        }
        
        return counts.max(by: { $0.value < $1.value })?.key
    }
    
    var body: some View {
        // Make the view scrollable
        ScrollView {
            VStack(spacing: 20) {
                // Display the card views for headache insights
                MostRecentHeadacheView(mostRecentHeadache: headaches.first ?? nil)
                    .frame(maxWidth: 400)
                
                /*
                 * Rather than passing in the list of headaches to the card view to calculate frequencies,
                 * triggers, and locations, we do it here and pass the 3 results into the views.
                 */
                MonthlyCardView(headacheCount: headachesLastMonth.count,
                                mostCommonMonthTrigger: mostCommonMonthTrigger,
                                mostCommonMonthLocation: mostCommonMonthLocation)
                    .frame(maxWidth: 400)
                
                LifetimeCardView(headacheCount: headaches.count,
                                 mostCommonLifetimeTrigger: mostCommonLifetimeTrigger,
                                 mostCommonLifetimeLocation: mostCommonLifetimeLocation)
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
