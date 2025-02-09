//
//  LocationClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/8/25.
//

import Foundation
import ComposableArchitecture
import CoreLocation

@DependencyClient
struct LocationClient {
    var authorizationStatus: @Sendable () -> CLAuthorizationStatus = { .denied }
    var requestAuthorization: @Sendable () -> Void
    var liveUpdates: @Sendable () -> CLLocationUpdate.Updates = { CLLocationUpdate.liveUpdates() }
}

extension CLLocationUpdate {
    func toDomain() -> LocationUpdate {
        return LocationUpdate()
    }
}

extension LocationClient: DependencyKey {
    
    static var liveValue: LocationClient = {
        return LocationClient(
            authorizationStatus: { CLLocationManager().authorizationStatus },
            requestAuthorization: { CLLocationManager().requestWhenInUseAuthorization() },
            liveUpdates: { CLLocationUpdate.liveUpdates() }
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


//
//private class LocationManager: NSObject {
//    private lazy var locationManager: CLLocationManager = {
//        let manager = CLLocationManager()
//        manager.delegate = self
//        manager.distanceFilter = kCLDistanceFilterNone
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        return manager
//    }()
//    private var continuation: AsyncThrowingStream<[CLLocation], any Error>.Continuation?
//    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, any Error>?
//    private var total: Double = 0.0
//    
//    @MainActor
//    func configure() {
//        self.locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    
//    @MainActor
//    func requestAuthorization() -> Void {
//        locationManager.requestWhenInUseAuthorization()
//    }
//    
//    @MainActor
//    func start() -> AsyncThrowingStream<[CLLocation], any Error> {
//        return AsyncThrowingStream { continuation in
//            self.continuation = continuation
//            locationManager.startUpdatingLocation()
//        }
//    }
//    
//    @MainActor
//    func stop() -> Void {
//        locationManager.stopUpdatingLocation()
//    }
//}
//
//extension LocationManager: CLLocationManagerDelegate {
//    nonisolated func locationManager(
//        _ manager: CLLocationManager,
//        didUpdateLocations locations: [CLLocation]
//    ) {
//        continuation?.yield(locations)
//    }
//    
//    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationContinuation?.resume(returning: manager.authorizationStatus)
//    }
//}
//
