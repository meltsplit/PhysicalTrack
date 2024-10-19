//
//  RankingResponse.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation

struct RankingResponse: Decodable {
    let consistencyRanking: [ConsistencyRankingResponse]
    let pushUpRanking: [PushUpRankingResponse]
    
    enum CodingKeys: String, CodingKey {
        case consistencyRanking = "consistency_ranking"
        case pushUpRanking = "pushup_ranking_week"
    }
}

struct ConsistencyRankingResponse: Decodable {
    let name: String
    let daysActive: Int
    let rank: Int
    
    enum CodingKeys: String, CodingKey {
        case name, rank
        case daysActive = "days_active"
    }
    
}

struct PushUpRankingResponse: Decodable {
    let name: String
    let quantity: Int
    let rank: Int
}


// MARK: - Mock data

extension RankingResponse {
    static let mock = Self(consistencyRanking: [.stub1,.stub2,.stub3], pushUpRanking: [.stub1,.stub2,.stub3])
}


extension ConsistencyRankingResponse {
    static let stub1 = Self(name: "장석우", daysActive: 11, rank: 1)
    static let stub2 = Self(name: "배진하", daysActive: 7, rank: 2)
    static let stub3 = Self(name: "조윤호", daysActive: 4, rank: 3)
}

extension PushUpRankingResponse {
    static let stub1 = Self(name: "장석우", quantity: 70, rank: 1)
    static let stub2 = Self(name: "배진하", quantity: 60, rank: 2)
    static let stub3 = Self(name: "조윤호", quantity: 50, rank: 3)
}
