//
//  Workout.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/20/24.
//

import Foundation

struct PushUpRecordDTO: Encodable {
    let quantity: Int
    let tempo: [Double]
}

extension PushUpRecordDTO {
    static func toDTO(with entity: PushUpRecord) -> Self {
        return PushUpRecordDTO(quantity: entity.count, tempo: entity.tempo)
    }
}



