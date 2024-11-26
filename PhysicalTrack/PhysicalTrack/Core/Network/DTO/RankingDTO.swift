//
//  RankingResponse.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation

struct ConsistencyRankingResponse: Decodable, RankingRepresentable {
    let userID: Int
    let name: String
    let rank: Int
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name, rank
        case value = "streakCount"
    }
}

struct PushUpRankingResponse: Decodable, RankingRepresentable {
    let userID: Int
    let name: String
    let rank: Int
    let value: Int
    
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name, rank
        case value = "quantity"
    }
}


// MARK: - Mock data


extension ConsistencyRankingResponse {
    static let stub1 = Self(userID: 1, name: "장석우",  rank: 1, value: 100)
    static let stub2 = Self(userID: 2, name: "배진하", rank: 2, value: 97)
    static let stub3 = Self(userID: 3, name: "조윤호", rank: 3, value: 94)
    static let stub4 = Self(userID: 4, name: "김철수", rank: 4, value: 91)
    static let stub5 = Self(userID: 5, name: "손흥민", rank: 5, value: 90)
    static let stub6 = Self(userID: 6, name: "음바페", rank: 6, value: 84)
}

extension PushUpRankingResponse {
    static let stub1 = Self(userID: 1, name: "장석우", rank: 1, value: 70)
    static let stub2 = Self(userID: 1, name: "배진하", rank: 2, value: 60)
    static let stub3 = Self(userID: 1, name: "조윤호", rank: 3, value: 50)
}
