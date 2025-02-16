//
//  RunningRecord.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/13/25.
//

import Foundation

enum RunningPolicy {
    static let totalDistance = 3000
    static let unitDistance = 100
}

struct RunningRecord: Equatable {
    let targetDuration: Duration
    let targetDistance = 3000
    
    var locations: [Location] = []
    var currentDuration: Duration = .seconds(0)
    var currentSeconds: Int { Int(currentDuration.components.seconds) }
    var currentDistance: Double = 0.0
    
    // 3km를 100m로 나누면 구간 30개가 나온다.
    // seconds 기준으로 기록된다.
    var timeIntervals: [TimeInterval] = Array(repeating: 0, count: RunningPolicy.totalDistance / RunningPolicy.unitDistance)

    var speed: Double {
        let hours = Double(currentSeconds) / 60
        let km: Double = Double(targetDistance) / 1000
        return km / hours
    }
    
    init(for grade: Grade) {
        self.targetDuration = RunningCriteria.table[grade]!.upperBound
    }
}

extension RunningRecord {
    func evaluate() -> Grade {
        RunningCriteria.evaluate(currentDuration)
    }
}
