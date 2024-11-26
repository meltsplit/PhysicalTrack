//
//  StatisticsResponse.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation

struct StatisticsResponse: Decodable {
    let date: Date
    let pushUpCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case date
        case pushUpCount = "pushup_count"
    }
}


// MARK: - Mock data

extension StatisticsResponse {
    static let mock = Self(
        date: Date(),
        pushUpCount: 54
    )
}
