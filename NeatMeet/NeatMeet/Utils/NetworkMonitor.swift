//
//  NetworkMonitor.swift
//  NeatMeet
//
//  Created by Damyant Jain on 11/27/24.
//


import Network
import UIKit

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            NotificationCenter.default.post(name: .connectivityStatusChanged, object: nil)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}

extension Notification.Name {
    static let connectivityStatusChanged = Notification.Name("connectivityStatusChanged")
}
