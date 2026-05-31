//
//  EpisodeLoggingWatchViewModel.swift
//
//  ViewModel to handle computations in the episode logging view for the watch companion app.
//
import SwiftUI
import SwiftData

@Observable
class EpisodeLoggingWatchViewModel {
    // State to represent the step the user is on
    var step: Int = 1

    // Track the user's input as they log the episode
    var input = EpisodeInput()
    
    // Track if we have saved the episode yet
    var didSave = false
    
    // Function to save episode to the phone app
    func saveEpisode() {
        guard !didSave else { return }
        let dto = EpisodeInput(
            onset: input.onset,
            movement: input.movement,
            intensity: input.intensity,
            stress: input.stress,
            bloating: input.bloating,
            stoolConsistency: input.stoolConsistency,
            stoolUrgency: input.stoolUrgency,
            stoolEffort: input.stoolEffort
        )
        do {
            let data = try JSONEncoder().encode(dto)
            WatchMessageManager.shared.sendEpisodeData(data) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        self.didSave = true
                    case .failure(let error):
                        print("send error:", error)
                    }
                }
            }
        } catch {
            print("encode error:", error)
        }
    }
}
