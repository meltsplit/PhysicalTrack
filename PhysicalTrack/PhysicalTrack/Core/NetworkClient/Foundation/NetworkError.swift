//
//  NetworkError.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/20/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case encodeFail
    case decodeFail
    case unknown
    case unauthorized
}
