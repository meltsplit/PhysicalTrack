//
//  RankingResponse.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation


struct ConsistencyRankingResponse: Decodable, Hashable {
    let userId: Int
    let name: String
    let streakCount: Int
    let rank: Int
}

struct PushUpRankingResponse: Decodable, Hashable {
    let userId: Int
    let name: String
    let quantity: Int
    let rank: Int
}


// MARK: - Mock data


extension ConsistencyRankingResponse {
    static let stub1 = Self(userId: 1, name: "장석우", streakCount: 100, rank: 1)
    static let stub2 = Self(userId: 2, name: "배진하", streakCount: 97, rank: 2)
    static let stub3 = Self(userId: 3, name: "조윤호", streakCount: 94, rank: 3)
    static let stub4 = Self(userId: 4, name: "김철수", streakCount: 91, rank: 4)
    static let stub5 = Self(userId: 5, name: "손흥민", streakCount: 90, rank: 5)
    static let stub6 = Self(userId: 6, name: "음바페", streakCount: 84, rank: 6)
}

extension PushUpRankingResponse {
    static let stub1 = Self(userId: 1, name: "장석우", quantity: 70, rank: 1)
    static let stub2 = Self(userId: 1, name: "배진하", quantity: 60, rank: 2)
    static let stub3 = Self(userId: 1, name: "조윤호", quantity: 50, rank: 3)
}
