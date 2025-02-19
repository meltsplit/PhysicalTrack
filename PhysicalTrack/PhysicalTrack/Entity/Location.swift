//
//  Location.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/9/25.
//

import Foundation
import CoreLocation
import ConcurrencyExtras


struct Location: Sendable {
    private let rawValue: CLLocation
    
    let speed: Double
    let timestamp: Date
    @UncheckedSendable var distance: ((_ location: Self) -> Double)
    
    init(
        rawValue: CLLocation
    ) {
        self.rawValue = rawValue
        self.speed = rawValue.speed
        self.timestamp = rawValue.timestamp
        self.distance = {
            rawValue.distance(from: $0.rawValue)
        }
    }
}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        ObjectIdentifier(lhs.rawValue) == ObjectIdentifier(rhs.rawValue)
    }
}

extension Location {
    private init(
        rawValue: CLLocation,
        speed: Double,
        timestamp: Date,
        distance: @escaping ((Self) -> Double)
    ) {
        self.rawValue = rawValue
        self.speed = speed
        self.timestamp = timestamp
        self.distance = distance
    }
    
    static func stub(
        speed: Double = 0,
        timestamp: Date = .now,
        distance: @escaping ((Self) -> Double) = { _ in 0 }
    ) -> Self {
        self.init(
            rawValue: .init(),
            speed: speed,
            timestamp: timestamp,
            distance: distance
        )
    }
}
