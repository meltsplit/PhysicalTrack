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
    var liveUpdates: @Sendable () -> CLLocationUpdate.Updates = {  CLLocationUpdate.liveUpdates() }
}

extension LocationClient: DependencyKey {
    
    static var liveValue: LocationClient = {
        return LocationClient(
            authorizationStatus: { CLLocationManager().authorizationStatus.toDomain() },
            requestAuthorization: { CLLocationManager().requestWhenInUseAuthorization() },
            liveUpdates: { CLLocationUpdate.liveUpdates(.fitness) }
        )
    }()
}

extension LocationClient: TestDependencyKey {
    static var previewValue: LocationClient = Self()
    static var testValue: LocationClient = Self()
}

extension DependencyValues {
    var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}
