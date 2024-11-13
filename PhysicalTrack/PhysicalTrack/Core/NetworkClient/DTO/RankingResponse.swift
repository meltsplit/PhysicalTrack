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


extension ConsistencyRankingResponse {
    static let stub1 = Self(userId: 1, name: "장석우", daysActive: 100, rank: 1)
    static let stub2 = Self(userId: 2, name: "배진하", daysActive: 97, rank: 2)
    static let stub3 = Self(userId: 3, name: "조윤호", daysActive: 94, rank: 3)
    static let stub4 = Self(userId: 4, name: "김철수", daysActive: 91, rank: 4)
    static let stub5 = Self(userId: 5, name: "손흥민", daysActive: 90, rank: 5)
    static let stub6 = Self(userId: 6, name: "음바페", daysActive: 84, rank: 6)
}

extension Array where Element == ConsistencyRankingResponse {
    static let stubs: [Element] = [
        .init(userId: 1, name: "장석우", daysActive: 100, rank: 1),
        .init(userId: 2, name: "배진하", daysActive: 97, rank: 2),
        .init(userId: 3, name: "조윤호", daysActive: 94, rank: 3),
        .init(userId: 4, name: "김철수", daysActive: 91, rank: 4),
        .init(userId: 5, name: "손흥민", daysActive: 90, rank: 5),
        .init(userId: 6, name: "음바페", daysActive: 84, rank: 6),
        .init(userId: 7, name: "이수현", daysActive: 83, rank: 7),
        .init(userId: 8, name: "황의조", daysActive: 82, rank: 8),
        .init(userId: 9, name: "정우영", daysActive: 80, rank: 9),
        .init(userId: 10, name: "이강인", daysActive: 79, rank: 10),
        .init(userId: 11, name: "기성용", daysActive: 78, rank: 11),
        .init(userId: 12, name: "조현우", daysActive: 77, rank: 12),
        .init(userId: 13, name: "김영권", daysActive: 76, rank: 13),
        .init(userId: 14, name: "이청용", daysActive: 75, rank: 14),
        .init(userId: 15, name: "홍철", daysActive: 74, rank: 15),
        .init(userId: 16, name: "김민재", daysActive: 73, rank: 16),
        .init(userId: 17, name: "백승호", daysActive: 72, rank: 17),
        .init(userId: 18, name: "박지성", daysActive: 71, rank: 18),
        .init(userId: 19, name: "안정환", daysActive: 70, rank: 19),
        .init(userId: 20, name: "이을용", daysActive: 69, rank: 20),
        .init(userId: 21, name: "최용수", daysActive: 68, rank: 21),
        .init(userId: 22, name: "서정원", daysActive: 67, rank: 22),
        .init(userId: 23, name: "이동국", daysActive: 66, rank: 23),
        .init(userId: 24, name: "차두리", daysActive: 65, rank: 24),
        .init(userId: 25, name: "김태영", daysActive: 64, rank: 25),
        .init(userId: 26, name: "송종국", daysActive: 63, rank: 26),
        .init(userId: 27, name: "유상철", daysActive: 62, rank: 27),
        .init(userId: 28, name: "최진철", daysActive: 61, rank: 28),
        .init(userId: 29, name: "김남일", daysActive: 60, rank: 29),
        .init(userId: 30, name: "김대의", daysActive: 59, rank: 30),
        .init(userId: 31, name: "박주영", daysActive: 58, rank: 31),
        .init(userId: 32, name: "이승우", daysActive: 57, rank: 32),
        .init(userId: 33, name: "남태희", daysActive: 56, rank: 33),
        .init(userId: 34, name: "조광래", daysActive: 55, rank: 34),
        .init(userId: 35, name: "최강희", daysActive: 54, rank: 35),
        .init(userId: 36, name: "허정무", daysActive: 53, rank: 36),
        .init(userId: 37, name: "김진수", daysActive: 52, rank: 37),
        .init(userId: 38, name: "정성룡", daysActive: 51, rank: 38),
        .init(userId: 39, name: "김기희", daysActive: 50, rank: 39),
        .init(userId: 40, name: "김주영", daysActive: 49, rank: 40),
        .init(userId: 41, name: "조영철", daysActive: 48, rank: 41),
        .init(userId: 42, name: "김동진", daysActive: 47, rank: 42),
        .init(userId: 43, name: "고요한", daysActive: 46, rank: 43),
        .init(userId: 44, name: "이정수", daysActive: 45, rank: 44),
        .init(userId: 45, name: "조성환", daysActive: 44, rank: 45),
        .init(userId: 46, name: "차상현", daysActive: 43, rank: 46),
        .init(userId: 47, name: "차범근", daysActive: 42, rank: 47),
        .init(userId: 48, name: "이용수", daysActive: 41, rank: 48),
        .init(userId: 49, name: "조한욱", daysActive: 40, rank: 49),
        .init(userId: 50, name: "강철", daysActive: 39, rank: 50)
    ]
}

extension PushUpRankingResponse {
    static let stub1 = Self(userId: 1, name: "장석우", quantity: 70, rank: 1)
    static let stub2 = Self(userId: 1, name: "배진하", quantity: 60, rank: 2)
    static let stub3 = Self(userId: 1, name: "조윤호", quantity: 50, rank: 3)
}
