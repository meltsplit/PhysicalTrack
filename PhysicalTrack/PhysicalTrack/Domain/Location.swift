//
//  Location.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/9/25.
//

import Foundation
import CoreLocation

struct Location {
    private let rawValue: CLLocation
    
    let speed: Double
    let timestamp: Date
    let distance: ((_ location: Self) -> Double)
    
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
        speed: Double,
        timestamp: Date,
        distance: @escaping ((Self) -> Double)
    ) -> Self {
        self.init(
            rawValue: .init(),
            speed: speed,
            timestamp: timestamp,
            distance: distance
        )
    }
}

//struct StubLocation: LocationType {
//    var stubDistance: Double
//    var speed: Double
//    var timestamp: Date
//    func distance(from location: Self) -> Double {
//        return stubDistance
//    }
//}

//struct AnyLocation {
//    public var base: any LocationType
//    
//    public init<L>(_ base: L) where L : LocationType {
//        self.base = base
//    }
//}
//
//extension AnyLocation: Equatable {
//    static func == (lhs: AnyLocation, rhs: AnyLocation) -> Bool {
//        lhs.base.speed == rhs.base.speed &&
//        lhs.base.timestamp == rhs.base.timestamp
//    }
//}
//
//extension AnyLocation: LocationType {
//    var speed: Double {
//        base.speed
//    }
//    
//    var timestamp: Date {
//        base.timestamp
//    }
//    
//    func distance(from location: AnyLocation) -> Double {
//        base.distance(from: location.base)
//    }
//}
