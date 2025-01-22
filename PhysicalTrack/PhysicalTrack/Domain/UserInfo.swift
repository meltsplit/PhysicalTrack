//
//  UserInfo.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/22/25.
//

import Foundation

struct UserInfo: Equatable {
    var name: String
    var gender: Gender
    var yearOfBirth: Int
}


extension UserInfo {
    static let stub: Self = .init(name: "스텁", gender: .male, yearOfBirth: 1111)
}
