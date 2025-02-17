//
//  CriterialModel.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/15/25.
//

import Foundation

struct CriteriaModel: Hashable, Identifiable {
    var id: Self { self }
    let grade: Grade
    let description: String
}
