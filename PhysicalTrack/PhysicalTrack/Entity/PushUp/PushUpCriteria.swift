//
//  PushUpCriteria.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/15/25.
//

import Foundation

struct PushUpCriteria {
    static let table: [Grade: ClosedRange<Int>] =  [
        .elite: 72...Int.max,
        .grade1: 64...71,
        .grade2: 56...63,
        .grade3: 48...55,
        .failed: 0...47
    ]
    
    static func evaluate(_ count: Int) -> Grade {
        table.first(where: { $0.value.contains(count)})?.key ?? .failed
    }
    
    static func toModels() -> [CriteriaModel] {
        table
            .sorted(by: { $0.key < $1.key})
            .map { grade, range in
                var description: String
                switch grade {
                case .elite: description = "\(range.lowerBound)회 이상"
                case .failed: description = "\(range.upperBound.description)회 이하"
                default: description = "\(range.lowerBound)회 ~ \(range.upperBound)회"
                }
                return CriteriaModel(grade: grade, description: description)
            }
    }
    
    static func toDescription(for grade: Grade) -> CriteriaDescription {
        guard grade != .failed,
              let minCount = table[grade]?.lowerBound
        else { return CriteriaDescription(
            description: "2분 동안 47회 미만 수행 시 불합격이에요.",
            highlight: "47회"
        ) }

        return CriteriaDescription(
            description: "2분 동안 \(minCount)회 이상 수행해야 해요.",
            highlight: "\(minCount)회"
        )
    }
}
