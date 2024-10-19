//
//  Workout.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

protocol Workout: Equatable {
    static func judgeGrade(_ value: Int) -> Grade
    
    static var criteriaDict: [Grade: ClosedRange<Int>] { get }
    static var criteriaArray: [GradeCriteria<Self>] { get }
}

extension Workout {
    static var criteriaArray: [GradeCriteria<Self>] {
        return Grade.allCases.map { .init(grade: $0) }
    }
    
    static func judgeGrade(_ value: Int) -> Grade {
        
        for grade in Grade.allCases {
            if Self.criteriaDict[grade]!.contains(value) { return grade }
        }
        return .failed
    }
}

