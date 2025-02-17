//
//  RankingRepresentable.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/26/24.
//

import Foundation

protocol RankingRepresentable: Hashable {
    var userID: Int { get }
    var name: String { get }
    var rank: Int { get }
    var value: Int { get }
}
