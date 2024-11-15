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
    
    var start: @Sendable () -> AsyncStream<Bool> = { .finished }
    var stop: @Sendable () -> Void
}

extension ProximityClient: TestDependencyKey {
    static let previewValue = Self(
        start: {
            var clock = ContinuousClock()
            return AsyncStream<Bool> { continuation in
                Task {
                    for try await _ in clock.timer(interval: .seconds(2)) {
                        continuation.yield(true)
                    }
                }
            }
        },
        stop: {
            return
        }
    )
    
    static let testValue = Self(
        start: { AsyncStream<Bool> { _ in }},
        stop: { }
    )

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
