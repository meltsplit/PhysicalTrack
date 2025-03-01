//
//  RankingResponse.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation

struct ConsistencyRankingResponse: Decodable, Equatable {
    let userID: Int
    let name: String
    let rank: Int
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name, rank
        case count = "streakCount"
    }
}

extension ConsistencyRankingResponse {
    func toDomain() -> RankingModel {
        return RankingModel(
            userID: userID,
            name: name,
            rank: rank,
            value: count,
            description: "\(count) 일째 운동 중"
        )
    }
}

struct PushUpRankingResponse: Decodable, Equatable {
    let userID: Int
    let name: String
    let rank: Int
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name, rank, quantity
    }
}

extension PushUpRankingResponse {
    func toDomain() -> RankingModel {
        return RankingModel(
            userID: userID,
            name: name,
            rank: rank,
            value: quantity,
            description: "\(quantity) 회"
        )
    }
}

struct RunningRankingResponse: Decodable, Equatable {
    let userID: Int
    let name: String
    let rank: Int
    let duration: Double
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name, rank, duration
    }
}

extension RunningRankingResponse {
    func toDomain() -> RankingModel {
        return RankingModel(
            userID: userID,
            name: name,
            rank: rank,
            value: Int(duration),
            description: Int(duration).to_분_초
        )
    }
}


// MARK: - Mock data


extension ConsistencyRankingResponse {
    static let stub1 = Self(userID: 1, name: "장석우",  rank: 1, count: 100)
    static let stub2 = Self(userID: 2, name: "배진하", rank: 2, count: 97)
    static let stub3 = Self(userID: 3, name: "조윤호", rank: 3, count: 94)
    static let stub4 = Self(userID: 4, name: "김철수", rank: 4, count: 91)
    static let stub5 = Self(userID: 5, name: "손흥민", rank: 5, count: 90)
    static let stub6 = Self(userID: 6, name: "음바페", rank: 6, count: 84)
}

extension PushUpRankingResponse {
    static let stub1 = Self(userID: 1, name: "장석우", rank: 1, quantity: 70)
    static let stub2 = Self(userID: 1, name: "배진하", rank: 2, quantity: 60)
    static let stub3 = Self(userID: 1, name: "조윤호", rank: 3, quantity: 50)
}

