//
//  GradeCriteria.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation

struct GradeCriteria<W: Workout>: Equatable, Hashable {
    let grade: Grade
    var value: ClosedRange<Int> {
        W.criteriaDict[grade]!
    }
    
    var description: String {
        guard value.lowerBound != Int.min
        else { return String(value.upperBound) + " 이하" }
        
        guard value.upperBound != Int.max
        else { return String(value.lowerBound) + " 이상" }
        
        return String(value.lowerBound) + " ~ " + String(value.upperBound)
    }
}
