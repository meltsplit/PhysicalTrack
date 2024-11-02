//
//  SignUp.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/2/24.
//

import Foundation

struct SignUpRequest: Encodable {
    let deviceId: String
    let name: String
    let age: Int
    let gender: String
}
