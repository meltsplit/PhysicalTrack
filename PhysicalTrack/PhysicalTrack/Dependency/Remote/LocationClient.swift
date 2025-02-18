//
//  LocationClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/8/25.
//

import Foundation
import ComposableArchitecture
import CoreLocation

extension CLAuthorizationStatus {
    func toDomain() -> AuthorizationStatus {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .unauthorized
        default:
            return .unauthorized
            
        }
    }
}

extension CLLocationUpdate {
    func toDomain() throws -> Location {
        guard let location else { throw NSError() }
        return Location(rawValue: location)
    }
    
}


@DependencyClient
struct LocationClient {
    var authorizationStatus: @Sendable () -> AuthorizationStatus = { .unauthorized }
    var requestAuthorization: @Sendable () -> Void
    var liveUpdates: @Sendable () -> AsyncStream<Location> = { .finished }
}

extension LocationClient: DependencyKey {
    
    static var liveValue: LocationClient = {
        return LocationClient(
            authorizationStatus: { CLLocationManager().authorizationStatus.toDomain() },
            requestAuthorization: { CLLocationManager().requestWhenInUseAuthorization() },
            liveUpdates: {
                return AsyncStream<Location> { continuation in
                    Task {
                        for try await clLocation in CLLocationUpdate.liveUpdates() {
                            guard let location = try? clLocation.toDomain() else { continue }
                            continuation.yield(location)
                        }
                    }
                }
            }
        )
    }()
}

extension LocationClient: TestDependencyKey {
    static var previewValue: LocationClient = Self(
        authorizationStatus: { .authorized },
        requestAuthorization: { },
        liveUpdates: {
            let (stream, continuation) = AsyncStream.makeStream(of: Location.self)
            Task {
//                continuation.yield(.stub(distance: { _ in 0 }))
//                sleep(2)
//                continuation.yield(.stub(distance: { _ in 1000 }))
//                sleep(1)
//                continuation.yield(.stub(distance: { _ in 1000 }))
//                sleep(1)
//                continuation.yield(.stub(distance: { _ in 999 }))
//                sleep(1)
//                continuation.yield(.stub(distance: { _ in 3 }))
                
                for _ in 0...31 {
                    continuation.yield(.stub(timestamp: Date(), distance: { _ in 100}))
                    try await Task.sleep(for: .seconds(1))
                }
                
            }
            return stream
        }
    )
    static var testValue: LocationClient = Self()
}

extension DependencyValues {
    var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}
