//
//  Grade.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

enum Grade: Int, Hashable, CaseIterable, Comparable {
    static func < (lhs: Grade, rhs: Grade) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case elite
    case grade1
    case grade2
    case grade3
    case failed
    
    var title: String {
        switch self {
        case .elite:
            "특급"
        case .grade1:
            "1급"
        case .grade2:
            "2급"
        case .grade3:
            "3급"
        case .failed:
            "불합격"
        }
    }
    
}



