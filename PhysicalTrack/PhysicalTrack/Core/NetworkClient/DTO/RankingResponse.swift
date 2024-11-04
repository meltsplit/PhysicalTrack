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

struct ConsistencyRankingResponse: Decodable, Hashable {
    let userId: Int
    let name: String
    let daysActive: Int
    let rank: Int
    
    enum CodingKeys: String, CodingKey {
        case name, rank, userId
        case daysActive = "days_active"
    }
    
}

struct PushUpRankingResponse: Decodable, Hashable {
    let userId: Int
    let name: String
    let quantity: Int
    let rank: Int
}


// MARK: - Mock data

extension RankingResponse {
    static let empty = Self(consistencyRanking: [], pushUpRanking: [])
    static let stub = Self(consistencyRanking: [.stub1,.stub2,.stub3, .stub4,.stub5,.stub6], pushUpRanking: [.stub1,.stub2,.stub3])
}


extension ConsistencyRankingResponse {
    static let stub1 = Self(userId: 1, name: "장석우", daysActive: 11, rank: 1)
    static let stub2 = Self(userId: 1, name: "배진하", daysActive: 7, rank: 2)
    static let stub3 = Self(userId: 1, name: "조윤호", daysActive: 4, rank: 3)
    static let stub4 = Self(userId: 1, name: "장석우", daysActive: 3, rank: 4)
    static let stub5 = Self(userId: 1, name: "배진하", daysActive: 2, rank: 5)
    static let stub6 = Self(userId: 1, name: "조윤호", daysActive: 1, rank: 6)
}

extension PushUpRankingResponse {
    static let stub1 = Self(userId: 1, name: "장석우", quantity: 70, rank: 1)
    static let stub2 = Self(userId: 1, name: "배진하", quantity: 60, rank: 2)
    static let stub3 = Self(userId: 1, name: "조윤호", quantity: 50, rank: 3)
}
