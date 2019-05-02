//
//  ReachabilityManager.swift
//  TelstraAssignment
//
//  Created by m-666346 on 02/05/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import Reachability
//Reachabilty
protocol ReachabilityManagerProtocol: AnyObject {
    func didChangeNetworkStatus(_ notification: Notification)
}

/// ReachabilityManager handles the device network status.
/// It sends delegate, when device goes offline or come to online.
class ReachabilityManager: NSObject {
    var reachability: Reachability!
    weak var networkManagerDelegate: ReachabilityManagerProtocol?
    static let sharedInstance: ReachabilityManager = { return ReachabilityManager() }()

    override init() {
        super.init()
        
        reachability = Reachability()!
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkManagerDelegate?.didChangeNetworkStatus(notification)
    }
    
    static func stopNotifier() {
        do {
            try (ReachabilityManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    static func isReachable(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection != .none {
            completed(ReachabilityManager.sharedInstance)
        }
    }
    
    static func isUnreachable(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection == .none {
            completed(ReachabilityManager.sharedInstance)
        }
    }
    
    static func isReachableViaWWAN(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection == .cellular {
            completed(ReachabilityManager.sharedInstance)
        }
    }
    
    static func isReachableViaWiFi(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection == .wifi {
            completed(ReachabilityManager.sharedInstance)
        }
    }
}
