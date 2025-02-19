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
    static let liveValue = previewValue
    static let previewValue = Self(
        start: {
            var clock = ContinuousClock()
            return AsyncStream<Bool> { [clock] continuation in
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

//extension ProximityClient: DependencyKey {
//    static let liveValue: Self = {
//        return .init(
//            start: {
//                return AsyncStream { continuation in
//                    Task { @MainActor in
//                        UIDevice.current.isProximityMonitoringEnabled = true
//                        let notification = NotificationCenter.default.notifications(named: UIDevice.proximityStateDidChangeNotification)
//                        for await _ in notification {
//                            let state = await MainActor.run { UIDevice.current.proximityState }
//                            continuation.yield(state)
//                        }
//                    }
//                    
//                    continuation.onTermination = { _ in
//                        Task { @MainActor in
//                            UIDevice.current.isProximityMonitoringEnabled = false
//                        }
//                    }
//                }
//                
//            }, stop: {
//                Task { @MainActor in
//                    UIDevice.current.isProximityMonitoringEnabled = false
//                }
//            })
//    }()
//}
