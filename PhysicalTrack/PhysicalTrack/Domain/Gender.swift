//
//  Gender.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/22/25.
//

import Foundation

enum Gender: CaseIterable {
    case male
    case female
    
    var title: String {
        switch self {
        case .male: "남자"
        case .female: "여자"
        }
    }
}
