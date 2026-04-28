//
//  LoggingView.swift
//  ibs-app
//
//  This view guides the user through logging episodes.
//
import SwiftUI
import SwiftData

/*
 * Here we make a temporary object to hold user input,
 * which will then be turned into an Episode object.
 */
struct EpisodeInput {
    var onset: Date = Date()
    var movement: Date = Date()
    var intensity: Double = 5
    var stress: Double = 5
    var bloating: Bool = false
    var triggers: [Trigger] = []
    var stools: [Stool] = []
}

struct LoggingView: View {
    // Access the configured model context
    @Environment(\.modelContext) private var context
    
    // Allow the user to click cancel and dismiss the logging flow
    @Environment(\.dismiss) private var dismiss
    
    // State to track which step the user is on
    @State private var step: Int = 1
    
    // State of the user's input as they go through the screen
    @State private var input = EpisodeInput()
    
    // State to track if we saved a user's episode yet
    @State private var didSave = false
    
    var body: some View {
        // Change the view programatically as the user clicks through the prompts
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
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
            backgroundStep
        case 2:
            triggerStep
        case 3:
            stoolStep
        case 4:
            summaryStep
        default:
            backgroundStep
        }
    }
    
    // Computed property to change the title based on the user's step
    private var navigationTitle: String {
        switch step {
        case 1: return "Background"
        case 2: return "Triggers"
        case 3: return "Recent Stool"
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
                Button("Done") {
                    saveEpisode()
                }
                // Provide user with a success haptic upon saving the episode
                .sensoryFeedback(.success, trigger: didSave)
            }
        }
    }
    
    // Computed property to build the episode on-the-fly
    private var builtEpisode: Episode {
        Episode(
            onset: input.onset,
            movement: input.movement,
            // Cast intensity to Int when saving the episode, since the input slider uses decimal increments to slide more smoothly, which means the user is saving a Double
            intensity: Int(input.intensity),
            stress: Int(input.stress),
            bloating: input.bloating,
            triggers: input.triggers,
            stools: input.stools
        )
    }
    
    // Function to save a episode when the user is done with the input flow
    private func saveEpisode() {
        if (!didSave) {
            context.insert(builtEpisode)
            
            do {
                try context.save()
                didSave = true
                dismiss()
            } catch {
                print("Error saving episode:", error)
            }
        }
    }

    // Display a DatePicker and slider to the user to input date/intensity
    var backgroundStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.accent)
                    
                    Text("When did your episode start?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                    
                DatePicker("Onset:",
                           selection: $input.onset,
                           in: ...Date(),
                           displayedComponents: [.date, .hourAndMinute])
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.accent)
                    
                    Text("When was your last bowel movement?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                DatePicker("Movement:",
                           selection: $input.movement,
                           in: ...Date(),
                           displayedComponents: [.date, .hourAndMinute])
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "speedometer")
                        .foregroundStyle(.accent)
                    
                    Text("How intense is your episode?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                // Make step 0.2 to make the slider more fluid, even though we truncate any decimals inputted
                Slider(value: $input.intensity, in: 1...10, step: 0.15)
                    .tint(.accent)
                
                HStack {
                    Spacer()
                 
                    Text("\(input.intensity, specifier: "%.0f") / 10")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "figure.mind.and.body")
                        .foregroundStyle(.accent)
                    
                    Text("How stressed are you?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                // Make step 0.2 to make the slider more fluid, even though we truncate any decimals inputted
                Slider(value: $input.stress, in: 1...10, step: 0.15)
                    .tint(.accent)
                
                HStack {
                    Spacer()
                    
                    Text("\(input.stress, specifier: "%.0f") / 10")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "balloon.fill")
                        .foregroundStyle(.accent)
                    
                    Toggle("Are you experiencing bloating?", isOn: $input.bloating)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding()
    }
    
    // Display a list of locations for the user to pick for their episode
    var triggerStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.accent)
                
                Text("What triggered your episode?")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            // Allow scrolling through trigger buttons for those using larger text sizes
            ScrollView {
                // Organize the list into a grid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                    ForEach(Trigger.allCases, id: \.self) { trig in
                        Button {
                            withAnimation(.easeInOut(duration: 0.1)) {
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
                                .background(input.triggers.contains(trig) ? Color.accentColor : Color.accentColor.opacity(0.15))
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
    
    // Display a list of triggers for the user to pick for their episode
    var stoolStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "toilet.fill")
                    .foregroundStyle(.accent)
                
                Text("How would you describe your stool?")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            // Allow scrolling through stool buttons for those using larger text sizes
            ScrollView {
                // Organize the list into a grid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                    ForEach(Stool.allCases, id: \.self) { stool in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                // Toggle selection
                                if input.stools.contains(stool) {
                                    input.stools.removeAll { $0 == stool }
                                } else {
                                    input.stools.append(stool)
                                }
                            }
                        } label: {
                            Text(stool.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(input.stools.contains(stool) ? .black : .primary)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(input.stools.contains(stool) ? Color.accentColor : Color.accentColor.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        // Use selection feedback to indicate to user that elements are being selected on screen
                        .sensoryFeedback(.selection, trigger: input.stools.contains(stool))
                    }
                }
            }
        }
        .padding()
    }
    
    // Display the user a summary of the episode they entered
    var summaryStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Review your episode:")
                .font(.headline)
                .foregroundStyle(.primary)
            
            // Allow scrolling through summary view for those using larger text sizes
            ScrollView {
                // Reuse the episode card with the built episode passed in
                EpisodeView(episodeToView: builtEpisode)
            }
        }
        .padding()
    }
}
