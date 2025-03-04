//
//  MainScene.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI

public enum MainScene: Hashable, Sendable {
    case workout
    case statistics
    case ranking
    case setting
    
    var title: String {
        switch self {
        case .workout:
            "운동"
        case .statistics:
            "통계"
        case .ranking:
            "순위"
        case .setting:
            "설정"
        }
    }
    
    var systemImage: String {
        switch self {
        case .workout:
            "figure.run"
        case .statistics:
            "chart.bar"
        case .ranking:
            "trophy"
        case .setting:
            "gearshape"
        }
    }
}
