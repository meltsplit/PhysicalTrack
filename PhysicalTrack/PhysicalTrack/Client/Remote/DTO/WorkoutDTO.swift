//
//  Workout.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/20/24.
//

import Foundation

struct PushUpRecordRequest: Encodable {
    let quantity: Int
    let tempo: [Double]
}

extension PushUpRecord {
    func toData() -> PushUpRecordRequest {
        return .init(quantity: count, tempo: tempo)
    }
}



