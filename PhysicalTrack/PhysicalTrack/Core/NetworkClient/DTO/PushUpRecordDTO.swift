//
//  Workout.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/20/24.
//

import Foundation

struct PushUpRecordDTO: Encodable {
    let workoutId: Int
    let workoutDetail: PushUpRecordDetailDTO
}

struct PushUpRecordDetailDTO: Encodable {
    let quantity: Int
}


extension PushUpRecordDTO {
    static func withEntity(_ entity: PushUpRecord) -> Self {
        Self(workoutId: 1, workoutDetail: .init(quantity: entity.count))
    }
}



