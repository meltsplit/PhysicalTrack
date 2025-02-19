//
//  ProximityClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/20/24.
//

import UIKit
@preconcurrency import Combine
import ComposableArchitecture

@DependencyClient
struct ProximityClient {
    var start: @Sendable () async -> AsyncStream<Bool> = { .finished }
    var stop: @Sendable () async -> Void
}

extension ProximityClient: TestDependencyKey {
//    static let liveValue = previewValue
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

extension ProximityClient: DependencyKey {
    static let liveValue: Self = {
        let proximity = Proximity()
        return Self(
            start: { proximity.start() },
            stop: { proximity.stop() }
        )
    }()
}

actor Proximity {
    private var cancellable: AnyCancellable?
    
    @MainActor
    func start() -> AsyncStream<Bool> {
        return AsyncStream<Bool> { continuation in
            UIDevice.current.isProximityMonitoringEnabled = true
            
            let cancellable = NotificationCenter.default.publisher(for: UIDevice.proximityStateDidChangeNotification)
                .map { _ in UIDevice.current.proximityState }
                .sink { state in
                    continuation.yield(state)
                }
            
            Task {
                await store(UncheckedSendable(cancellable))
            }
        }
    }
    
    @MainActor
    func stop() -> Void {
        UIDevice.current.isProximityMonitoringEnabled = false
        Task {
            await store(nil)
        }
    }
    
    func store(_ cancellable: UncheckedSendable<AnyCancellable>?) {
        self.cancellable = cancellable?.wrappedValue
    }
}
