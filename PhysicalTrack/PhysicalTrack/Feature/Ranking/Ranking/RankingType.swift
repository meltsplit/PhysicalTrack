//
//  RankingType.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation

enum RankingType: Int, HeaderItemType {
    
    case consistency
    case pushUp
    
    var title: String {
        switch self {
        case .consistency: "꾸준함"
        case .pushUp: "팔굽혀펴기"
        }
    }
}
