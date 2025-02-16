//
//  GenderDTO.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/22/25.
//

import Foundation

enum GenderDTO: String ,Codable {
    case male = "male"
    case female = "female"
}

extension GenderDTO {
    func toDomain() -> Gender {
        switch self {
        case .male: return .male
        case .female: return .female
        }
    }
}

extension Gender {
    func toData() -> GenderDTO {
        switch self {
        case .male: return .male
        case .female: return .female
        }
    }
}
