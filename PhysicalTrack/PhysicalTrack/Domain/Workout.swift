//
//  Workout.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

struct GradeCriteria: Equatable, Hashable {
    let grade: WorkoutGrade
    let value: ClosedRange<Int>
    
    var description: String {
        guard value.lowerBound != Int.min 
        else { return String(value.upperBound) + " 이하" }
        
        guard value.upperBound != Int.max
        else { return String(value.lowerBound) + " 이상" }
        
        return String(value.lowerBound) + " - " + String(value.upperBound)
    }
}

protocol Workout: Equatable {
    static func getValue(_ grade: WorkoutGrade) -> ClosedRange<Int>
    
    static func judgeGrade(_ value: Int) -> WorkoutGrade
    
    static var list: [GradeCriteria] { get }
}

extension Workout {
    static var list: [GradeCriteria] {
        return WorkoutGrade.allCases.map { .init(grade: $0, value: getValue($0)) }
    }
    
    static func judgeGrade(_ value: Int) -> WorkoutGrade {
        
        for grade in WorkoutGrade.allCases {
            if Self.getValue(grade).contains(value) { return grade }
        }
        return .failed
    }
}

