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
    var count: Int
    var tempo : [Double]
    
    var pace: Double {
        Double(count) / Double(duration.components.seconds)
    }
    
    init(for grade: Grade) {
        self.init(
            duration: .seconds(120),
            targetCount: PushUpCriteria.table[grade]?.lowerBound ?? 0,
            count: 0,
            tempo: []
        )
    }
    
    init(
        duration: Duration,
        targetCount: Int,
        count: Int,
        tempo: [Double]
    ) {
        self.duration = duration
        self.targetCount = targetCount
        self.count = count
        self.tempo = tempo
    }
    
    static func stub(
        duration: Duration = .seconds(120),
        targetCount: Int = 72,
        count: Int = 0,
        tempo: [Double] = []
    ) -> PushUpRecord {
        self.init(duration: duration, targetCount: targetCount, count: count, tempo: tempo)
    }
}


extension PushUpRecord {
    func evaluate() -> Grade {
        PushUpCriteria.evaluate(count)
    }
}
