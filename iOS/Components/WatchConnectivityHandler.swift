//
//  WatchConnectivityHandler.swift
//
//  Handles connectivity between the phone and companion watch app.
//
import Foundation
import WatchConnectivity
import SwiftData
import Combine
import os

final class WatchConnectivityHandler: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityHandler()

    // ObservableObject requirement
    let objectWillChange = ObservableObjectPublisher()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ios", category: "WatchConnectivity")

    private override init() { super.init() }

    // Require passed in model context for SwiftData
    private var modelContext: ModelContext?

    // Initialization function
    func start(with modelContext: ModelContext) {
        self.modelContext = modelContext
        guard WCSession.isSupported() else {
            logger.info("WCSession not supported")
            return
        }
        let session = WCSession.default
        session.delegate = self
        session.activate()
        logger.info("WCSession start called")
    }

    // Session activation
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            logger.error("activation error: \(error.localizedDescription)")
        }
        logger.info("activation state: \(String(describing: activationState.rawValue)) reachable: \(session.isReachable) paired: \(session.isPaired) watchAppInstalled: \(session.isWatchAppInstalled)")
    }

    // Stub for session becoming inactive
    func sessionDidBecomeInactive(_ session: WCSession) {
        logger.info("sessionDidBecomeInactive")
    }

    // Stub for session deactivation
    func sessionDidDeactivate(_ session: WCSession) {
        logger.info("sessionDidDeactivate - reactivating")
        WCSession.default.activate()
    }

    // Incoming immediate message obtained through the watch's sendMessage
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: (([String : Any]) -> Void)) {
        logger.info("didReceiveMessage keys: \(Array(message.keys))")
        if let data = message["meal"] as? Data {
            logger.info("didReceiveMessage meal data size: \(data.count)")
            handleMealData(data)
        }
        
        if let data = message["episode"] as? Data {
            logger.info("didReceiveMessage episode data size: \(data.count)")
            handleEpisodeData(data)
        }
        replyHandler(["status": "received"])
    }

    // Incoming queued userInfo (transferUserInfo)
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        logger.info("didReceiveUserInfo keys: \(Array(userInfo.keys))")
        if let data = userInfo["meal"] as? Data {
            logger.info("didReceiveUserInfo meal data size: \(data.count)")
            handleMealData(data)
        }
        
        if let data = userInfo["episode"] as? Data {
            logger.info("didReceiveUserInfo episode data size: \(data.count)")
            handleEpisodeData(data)
        }
    }

    // Reachability notifications
    func sessionReachabilityDidChange(_ session: WCSession) {
        logger.info("reachability changed: reachable=\(session.isReachable)")
    }

    // Helper to decode & insert meals into SwiftData
    private func handleMealData(_ data: Data) {
        guard let modelContext = modelContext else {
            logger.error("modelContext is nil; cannot insert meal")
            return
        }

        do {
            let dto = try JSONDecoder().decode(MealInput.self, from: data)
            DispatchQueue.main.async {
                self.logger.info("inserting meal date: \(dto.date.debugDescription)")
                
                let meal = Meal(date: dto.date, foods: dto.foods)
                
                modelContext.insert(meal)
                do {
                    try modelContext.save()
                    self.logger.info("saved meal")
                } catch {
                    self.logger.error("save error: \(error.localizedDescription)")
                }
            }
        } catch {
            logger.error("decode MealDTO error: \(error.localizedDescription)")
        }
    }
    
    // Helper to decode & insert episodes into SwiftData
    private func handleEpisodeData(_ data: Data) {
        guard let modelContext = modelContext else {
            logger.error("modelContext is nil; cannot insert episode")
            return
        }

        do {
            let dto = try JSONDecoder().decode(EpisodeInput.self, from: data)
            DispatchQueue.main.async {
                self.logger.info("inserting episode date: \(dto.onset.debugDescription)")
                let episode = EpisodeBuilder.build(
                    from: dto,
                    type: dto.type
                )

                modelContext.insert(episode)

                do {
                    try modelContext.save()
                    self.logger.info("saved episode")
                } catch {
                    self.logger.error("save episode error: \(error.localizedDescription)")
                }
            }

        } catch {
            logger.error("decode EpisodeInput error: \(error.localizedDescription)")
        }
    }
}
