//
//  Exercise.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/13/25.
//

import Foundation

enum Exercise: CaseIterable {
    case pushUp
    case running
    
    var title: String {
        switch self {
        case .pushUp: return "팔굽혀펴기"
        case .running: return "3km 달리기"
        }
    }
}
