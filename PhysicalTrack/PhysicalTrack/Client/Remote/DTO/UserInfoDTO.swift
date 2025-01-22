//
//  UserInfoDTO.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/22/25.
//

import Foundation

struct UserInfoRequest: Encodable {
    var name: String
    var gender: GenderDTO
    var birthYear: Int
}

struct UserInfoResponse: Decodable {
    var userID: Int
    var gender: GenderDTO
    var name: String
    var birthYear: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case gender, name, birthYear
    }
}

//MARK: - Mapper

extension UserInfo {
    func toData() -> UserInfoRequest {
        .init(
            name: name,
            gender: gender.toData(),
            birthYear: yearOfBirth
        )
    }
}

extension UserInfoResponse {
    func toDomain() -> UserInfo {
        .init(
            name: name,
            gender: gender.toDomain(),
            yearOfBirth: birthYear
        )
    }
}
