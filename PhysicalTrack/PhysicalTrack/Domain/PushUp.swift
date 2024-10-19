//
//  PushUp.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

struct PushUp: Workout {
    
    static func getValue(_ grade: Grade) -> ClosedRange<Int> {
        switch grade {
        case .elite:
            72...Int.max
        case .grade1:
            64...71
        case .grade2:
            56...63
        case .grade3:
            48...55
        case .failed:
            Int.min...47
        }
    }
}

