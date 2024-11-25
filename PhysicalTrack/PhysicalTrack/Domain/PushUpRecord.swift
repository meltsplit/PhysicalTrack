//
//  WorkoutEntity.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

struct PushUpRecord: Equatable {
    var duration: Duration
    var targetCount: Int
    var count: Int
    
    var grade: Grade {
        PushUp.judgeGrade(count)
    }
    
    var pace: Double {
        Double(count) / Double(duration.components.seconds)
    }
    
    init(for grade: Grade) {
        self.duration = .seconds(120)
        self.targetCount = PushUp.criteriaDict[grade]!.lowerBound
        self.count = 0
    }
    
    init(duration: Duration, targetCount: Int) {
        self.duration = duration
        self.targetCount = targetCount
        self.count = 0
    }
}
