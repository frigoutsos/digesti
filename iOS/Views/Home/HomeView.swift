//
//  HomeView.swift
//
//  This view holds the app's home screen.
//
import SwiftUI

struct HomeView: View {
    // Track our navigation manager component
    @Bindable var navigationManager: NavigationManager
    
    // Get current theme color stored by the user
    @AppStorage("appTheme") private var appThemeRawValue: String = AppTheme.system.rawValue
    
    // Get the system's theme color in case user has app match to system color
    @Environment(\.colorScheme) private var colorScheme
    
    // State to keep track if we played the animation on the graphics
    @State private var dropped: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Homepage welcome
                VStack(spacing: 12) {
                    ZStack {
                        HomeGraphicBack()
                            .foregroundStyle(.homeGraphicBack)
                            .modifier(dropEffect(index: 0, dropped: dropped))
                        // Conditional shadow based on color scheme, sorry for the jankiness
                            .shadow(color: ((appThemeRawValue == AppTheme.light.rawValue) ||
                                            ((appThemeRawValue == AppTheme.system.rawValue) &&
                                             (colorScheme == .light))) ? Color(.systemGray) : Color(.white), radius: 10)
                        
                        HomeGraphicMiddle()
                            .foregroundStyle(.homeGraphicMiddle)
                            .modifier(dropEffect(index: 1, dropped: dropped))
                        
                        HomeGraphicFront()
                            .foregroundStyle(.homeGraphicFront)
                            .modifier(dropEffect(index: 2, dropped: dropped))
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .onAppear {
                        // Slight delay before starting so it feels intentional
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.75, blendDuration: 0)) {
                                dropped = true
                            }
                        }
                    }
                    
                    Text("Track Meals and IBS Episodes")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Uncover invisible patterns behind your symptoms.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button {
                    navigationManager.presentEpisodeLogger()
                } label: {
                    Label("Log Episode", systemImage: "bolt.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
                .padding(.horizontal, 48)
                
                Button {
                    navigationManager.presentMealLogger()
                } label: {
                    Label("Log Meal", systemImage: "fork.knife")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
                .padding(.horizontal, 48)
                
                Spacer()
            }
            .navigationTitle("Home")
            // Direct the user to the logging view after clicking the log button
            .sheet(item: $navigationManager.activeSheet) { (sheetType: NavigationManager.SheetType) in
                switch sheetType {
                case .episode:
                    EpisodeLoggingView()
                case .meal:
                    MealLoggingView()
                }
            }
        }
    }
}

// View Modifier to allow for dropping in graphics
struct dropEffect: ViewModifier {
    let index: Int
    let dropped: Bool

    func body(content: Content) -> some View {
        // Per-layer timing allows smaller index to appear earlier
        let delay = Double(index) * 0.06
        let spring = Animation.interpolatingSpring(stiffness: 220, damping: 22)
            .delay(delay)

        content
            .scaleEffect(dropped ? 1 : 0.92)
            .opacity(dropped ? 1 : 0)
            .offset(y: dropped ? 0 : -48)
            .animation(spring, value: dropped)
            .shadow(color: Color.black.opacity(0.06 + Double(index) * 0.02),
                    radius: CGFloat(6 - index), y: CGFloat(2 + index))
            .blendMode(.normal)
    }
}
