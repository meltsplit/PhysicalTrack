//
//  WorkoutEntity.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

struct PushUpRecord: Equatable {
    let duration: Duration
    let targetCount: Int
    var count: Int = 0
    var tempo : [Double] = []
    
    var pace: Double {
        Double(count) / Double(duration.components.seconds)
    }
    
    init(for grade: Grade) {
        self.duration = .seconds(120)
        self.targetCount = PushUpCriteria.table[grade]?.lowerBound ?? 0
    }
    
    init(duration: Duration, targetCount: Int) {
        self.duration = duration
        self.targetCount = targetCount
        self.count = 0
    }
}

extension PushUpRecord {
    func evaluate() -> Grade {
        PushUpCriteria.evaluate(count)
    }
}
