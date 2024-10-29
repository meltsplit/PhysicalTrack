//
//  ProximityClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/20/24.
//

import UIKit
import Combine
import ComposableArchitecture

@DependencyClient
struct ProximityClient {
    let start: @Sendable () -> AsyncStream<Bool>
    var stop: @Sendable () -> Void
}

extension ProximityClient: TestDependencyKey {
    static let previewValue = Self(
        start: {
            return AsyncStream<Bool> { continuation in
                continuation.yield(true)
                continuation.finish()
            }
        },
        stop: {
            return
        }
    )
    
    static let testValue = previewValue
}

extension DependencyValues {
    var proximityClient: ProximityClient {
        get { self[ProximityClient.self] }
        set { self[ProximityClient.self] = newValue }
    }
}

extension ProximityClient: DependencyKey {
    static let liveValue: Self = {
        return .init(
            start: {
                return AsyncStream { continuation in
                    Task { @MainActor in
                        UIDevice.current.isProximityMonitoringEnabled = true
                        
                        let observer = NotificationCenter.default.addObserver(
                            forName: UIDevice.proximityStateDidChangeNotification,
                            object: nil,
                            queue: nil
                        ) { _ in
                            Task { @MainActor in
                                guard UIDevice.current.isProximityMonitoringEnabled else {
                                    continuation.finish()
                                    return
                                }
                                continuation.yield(UIDevice.current.proximityState)
                                
                            }
                        }
                        
                        continuation.onTermination = { _ in
                            NotificationCenter.default.removeObserver(observer)
                        }
                        
                    }
                }
                
            }, stop: {
                Task { @MainActor in
                    UIDevice.current.isProximityMonitoringEnabled = false
                }
            })
    }()
}
