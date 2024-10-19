//
//  Workout.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

struct GradeCriteria<W: Workout>: Equatable, Hashable {
    let grade: Grade
    var value: ClosedRange<Int> {
        W.getValue(grade)
    }
    
    var description: String {
        guard value.lowerBound != Int.min 
        else { return String(value.upperBound) + " 이하" }
        
        guard value.upperBound != Int.max
        else { return String(value.lowerBound) + " 이상" }
        
        return String(value.lowerBound) + " - " + String(value.upperBound)
    }
}

protocol Workout: Equatable {
    static func getValue(_ grade: Grade) -> ClosedRange<Int>
    
    static func judgeGrade(_ value: Int) -> Grade
    
    static var list: [GradeCriteria<Self>] { get }
}

extension Workout {
    static var list: [GradeCriteria<Self>] {
        return Grade.allCases.map { .init(grade: $0) }
    }
    
    static func judgeGrade(_ value: Int) -> Grade {
        
        for grade in Grade.allCases {
            if Self.getValue(grade).contains(value) { return grade }
        }
        return .failed
    }
}

