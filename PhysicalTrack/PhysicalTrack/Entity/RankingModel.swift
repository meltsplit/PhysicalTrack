//
//  RankingRepresentable.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/26/24.
//

import Foundation

struct RankingModel: Hashable {
    var userID: Int
    var name: String
    var rank: Int
    var value: Int
    var description: String
}

//protocol RankingRepresentable: Hashable {
//    var userID: Int { get }
//    var name: String { get }
//    var rank: Int { get }
//    var value: Int { get }
//    func description() -> String
//}
//
//struct AnyRankingModel {
//    private let base: any RankingRepresentable
//
//    init(base: some RankingRepresentable) {
//        if let base = base as? AnyRankingModel {
//          self = base
//        } else {
//          self.base = base
//        }
//    }
//}
//
//extension AnyRankingModel {
//    var userID: Int { base.userID }
//    var name: String { base.name }
//    var rank: Int { base.rank }
//    var value: Int { base.value }
//    var description: String { base.description() }
//}
//
//extension AnyRankingModel: Equatable {
//    static func == (lhs: AnyRankingModel, rhs: AnyRankingModel) -> Bool {
//        AnyHashable(lhs.base) == AnyHashable(rhs.base)
//    }
//}
