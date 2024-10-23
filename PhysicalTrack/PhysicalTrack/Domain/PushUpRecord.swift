//
//  WorkoutEntity.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

struct PushUpRecord: Equatable {
    var targetSeconds: Int
    var targetCount: Int
    
    var time: Int
    var count: Int
    
    var grade: Grade {
        PushUp.judgeGrade(count)
    }
    
    var pace: Double {
        Double(count) / Double(time)
    }
    
    init(for grade: Grade) {
        self.targetSeconds = 10
        self.targetCount = PushUp.criteriaDict[grade]!.lowerBound
        self.time = 0
        self.count = 0
    }
}
