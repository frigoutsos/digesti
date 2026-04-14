//
//  LoggingView.swift
//  AheadAche
//
//  This view guides the user through logging headaches.
//
//  Created by Franklin Rigoutsos on 1/20/26.
//
import SwiftUI
import SwiftData

/*
 * Here we make a temporary object to hold user input,
 * which will then be turned into a Headache object.
 */
struct HeadacheInput {
    var intensity: Double = 5
    var onsetDateAndTime: Date = Date()
    var locations: [HeadacheLocation] = []
    var triggers: [HeadacheTrigger] = []
}

struct LoggingView: View {
    // Access the configured model context
    @Environment(\.modelContext) private var context
    
    // Allow the user to click cancel and dismiss the logging flow
    @Environment(\.dismiss) private var dismiss
    
    // State to track which step the user is on
    @State private var step: Int = 1
    
    // State of the user's input as they go through the screen
    @State private var input = HeadacheInput()
    
    // State to track if we saved a user's headache yet
    @State private var didSave = false
    
    var body: some View {
        // Change the view programatically as the user clicks through the prompts
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 12) {
                    Text("Progress:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    
                    // Display a progress bar to the user
                    ProgressView(value: Double(step), total: 4)
                        .tint(.blue)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 48)
                
                // Programmatically change the content displayed based on the user's step
                VStack(spacing: 16) {
                    stepContent
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
        }
    }
    
    // Change the content to display above based on the user's step
    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case 1:
            timeAndIntensityStep
        case 2:
            locationStep
        case 3:
            triggerStep
        case 4:
            summaryStep
        default:
            timeAndIntensityStep
        }
    }
    
    // Computed property to change the title based on the user's step
    private var navigationTitle: String {
        switch step {
        case 1: return "Time and Intensity"
        case 2: return "Location"
        case 3: return "Triggers"
        case 4: return "Summary"
        default: return ""
        }
    }
    
    // Change the toolbar items based on the user's step
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if step > 1 {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back") {
                    step -= 1
                }
            }
        } else {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            if step < 4 {
                Button("Next") {
                    step += 1
                }
            } else {
                Button("Done", role: .confirm) {
                    saveHeadache()
                }
                // Provide user with a success haptic upon saving the headache
                .sensoryFeedback(.success, trigger: didSave)
            }
        }
    }
    
    // Computed property to build the headache on the fly
    private var builtHeadache: Headache {
        Headache(
            onsetDateAndTime: input.onsetDateAndTime,
            // Cast intensity to Int when saving the headache, since the input slider uses decimal increments to slide more smoothly, which means the user is saving a Double
            intensity: Int(input.intensity),
            locations: input.locations,
            triggers: input.triggers
        )
    }
    
    // Function to save a headache when the user is done with the input flow
    private func saveHeadache() {
        if (!didSave) {
            context.insert(builtHeadache)
            
            do {
                try context.save()
                didSave = true
                dismiss()
            } catch {
                print("Error saving headache:", error)
            }
        }
    }

    // Display a DatePicker and slider to the user to input date/intensity
    var timeAndIntensityStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            Label("When did your headache start?", systemImage: "calendar")
                .font(.headline)
                .foregroundStyle(.blue)
                
            DatePicker("Onset:",
                       selection: $input.onsetDateAndTime,
                       in: ...Date(),
                       displayedComponents: [.date, .hourAndMinute])
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            Label("How intense is your headache?", systemImage: "speedometer")
                .font(.headline)
                .foregroundStyle(.red)
            
            // Make step 0.2 to make the slider more fluid, even though we truncate any decimals inputted
            Slider(value: $input.intensity, in: 1...10, step: 0.15)
                .tint(.red)
            
            HStack {
                Text("Intensity")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Intensity: \(input.intensity, specifier: "%.0f") / 10")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }
    
    // Display a list of locations for the user to pick for their headache
    var locationStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            Label("Where does your headache hurt most?", systemImage: "location.fill")
                .font(.headline)
                .foregroundStyle(.orange)
            
            // Allow scrolling through location buttons for those using larger text sizes
            ScrollView {
                // Organize the list into a grid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                    ForEach(HeadacheLocation.allCases, id: \.self) { loc in
                        Button {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                // Toggle selection
                                if input.locations.contains(loc) {
                                    input.locations.removeAll { $0 == loc }
                                } else {
                                    input.locations.append(loc)
                                }
                            }
                        } label: {
                            Text(loc.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(input.locations.contains(loc) ? .black : .primary)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(input.locations.contains(loc) ? Color.orange : Color.orange.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        // Use selection feedback to indicate to user that elements are being selected on screen
                        .sensoryFeedback(.selection, trigger: input.locations.contains(loc))
                    }
                }
            }
        }
        .padding()
    }
    
    // Display a list of triggers for the user to pick for their headache
    var triggerStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            Label("What triggered your headache?", systemImage: "bolt.fill")
                .font(.headline)
                .foregroundStyle(.yellow)
            
            // Allow scrolling through trigger buttons for those using larger text sizes
            ScrollView {
                // Organize the list into a grid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                    ForEach(HeadacheTrigger.allCases, id: \.self) { trig in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                // Toggle selection
                                if input.triggers.contains(trig) {
                                    input.triggers.removeAll { $0 == trig }
                                } else {
                                    input.triggers.append(trig)
                                }
                            }
                        } label: {
                            Text(trig.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(input.triggers.contains(trig) ? .black : .primary)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(input.triggers.contains(trig) ? Color.yellow : Color.yellow.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        // Use selection feedback to indicate to user that elements are being selected on screen
                        .sensoryFeedback(.selection, trigger: input.triggers.contains(trig))
                    }
                }
            }
        }
        .padding()
    }
    
    // Display the user a summary of the headache they entered
    var summaryStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            Label("Review your headache:", systemImage: "checkmark.circle.fill")
                .font(.headline)
                .foregroundStyle(.green)
            
            // Allow scrolling through summary view for those using larger text sizes
            ScrollView {
                // Reuse the headache card with the built headache passed in
                HeadacheView(headacheToView: builtHeadache)
            }
        }
        .padding()
    }
}
