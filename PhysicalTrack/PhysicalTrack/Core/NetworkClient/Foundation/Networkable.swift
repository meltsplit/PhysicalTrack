//
//  Networkable.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture

protocol Networkable {
    static var jsonDecoder: JSONDecoder { get }
}

extension Networkable {
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: -9 * 24 * 60 * 60)
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}
