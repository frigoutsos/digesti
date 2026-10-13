////
////  WatchMessageManager.swift
////
////  Watch-facing message state management.
////
//import Foundation
//import WatchConnectivity
//import os
//
//final class WatchMessageManager: NSObject, WCSessionDelegate {
//    static let shared = WatchMessageManager()
//    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "watch", category: "WatchMessageManager")
//    private override init() { super.init() }
//
//    private var session: WCSession { WCSession.default }
//
//    func start() {
//        guard WCSession.isSupported() else {
//            logger.info("WCSession not supported")
//            return
//        }
//        session.delegate = self
//        session.activate()
//        logger.info("WCSession activated on watch")
//    }
//
//    // Send data from a logged meal back to the phone
//    func sendMealData(_ data: Data, completion: ((Result<Void, Error>) -> Void)? = nil) {
//        let payload: [String: Any] = ["meal": data]
//        
//        guard session.activationState == .activated else {
//            queueEpisodeData(data, completion: completion)
//            return
//        }
//
//        if session.isReachable {
//            session.sendMessage(payload, replyHandler: { reply in
//                self.logger.info("sendMessage reply: \(reply)")
//                completion?(.success(()))
//            }, errorHandler: { error in
//                self.logger.error("sendMessage error: \(error.localizedDescription)")
//                // try transferUserInfo as fallback
//                self.queueMealData(data, completion: completion)
//            })
//        } else {
//            queueMealData(data, completion: completion)
//        }
//    }
//
//    // Queue as userInfo for delivery when connectivity returns
//    private func queueMealData(_ data: Data, completion: ((Result<Void, Error>) -> Void)? = nil) {
//        do {
//            try session.updateApplicationContext(["lastQueuedMealDate": Date().timeIntervalSince1970]) // optional small context
//        } catch {
//            logger.error("updateApplicationContext error: \(error.localizedDescription)")
//        }
//        session.transferUserInfo(["meal": data])
//        logger.info("transferUserInfo queued")
//        completion?(.success(()))
//    }
//    
//    // Send data from a logged episode back to the phone
//    func sendEpisodeData(_ data: Data, completion: ((Result<Void, Error>) -> Void)? = nil) {
//        let payload: [String: Any] = ["episode": data]
//
//        guard session.activationState == .activated else {
//            queueEpisodeData(data, completion: completion)
//            return
//        }
//
//        if session.isReachable {
//            session.sendMessage(payload, replyHandler: { reply in
//                self.logger.info("episode reply: \(reply)")
//                completion?(.success(()))
//            }, errorHandler: { error in
//                self.logger.error("episode sendMessage error: \(error.localizedDescription)")
//                self.queueEpisodeData(data, completion: completion)
//            })
//        } else {
//            queueEpisodeData(data, completion: completion)
//        }
//    }
//    
//    // Queue as userInfo for delivery when connectivity returns
//    private func queueEpisodeData(_ data: Data, completion: ((Result<Void, Error>) -> Void)? = nil) {
//        do {
//            try session.updateApplicationContext(["lastQueuedEpisodeDate": Date().timeIntervalSince1970])
//        } catch {
//            logger.error("updateApplicationContext error: \(error.localizedDescription)")
//        }
//
//        session.transferUserInfo(["episode": data])
//        logger.info("episode transferUserInfo queued")
//
//        completion?(.success(()))
//    }
//
//    // WCSessionDelegate minimal implementations
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        if let e = error { logger.error("activation error: \(e.localizedDescription)") }
//        logger.info("activationDidComplete state: \(activationState.rawValue)")
//    }
//
//    #if os(iOS)
//    // iOS-only delegate stubs (not needed on watch but harmless if compiled)
//    func sessionDidBecomeInactive(_ session: WCSession) {}
//    func sessionDidDeactivate(_ session: WCSession) { WCSession.default.activate() }
//    #endif
//
//    func sessionReachabilityDidChange(_ session: WCSession) {
//        logger.info("reachability changed: \(session.isReachable)")
//    }
//}
