//
//  DTO.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation


struct VoidDTO: Decodable {
    let status: Int
    let message: String
}

struct DTO<D: Decodable>: Decodable {
    let status: Int
    let message: String
    let data: D
}

extension DTO {
    static func success(_ dto: D) -> Self {
        Self(status: 200, message: "", data: dto)
    }
    
    static func fail(_ dto: D) -> Self {
        Self(status: 400, message: "", data: dto)
    }
}
