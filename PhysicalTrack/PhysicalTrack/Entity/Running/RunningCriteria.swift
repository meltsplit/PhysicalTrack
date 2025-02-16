//
//  RunningCriteria.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/15/25.
//

import Foundation

struct RunningCriteria {
    static let table: [Grade: ClosedRange<Duration>] = [
        .elite: .seconds(0)...(.seconds(750)),
        .grade1: .seconds(751)...(.seconds(812)),
        .grade2: .seconds(813)...(.seconds(844)),
        .grade3: .seconds(845)...(.seconds(906)),
        .failed: .seconds(906)...(.seconds(Int.max))
    ]
    
    static func evaluate(_ count: Duration) -> Grade {
        table.first(where: { $0.value.contains(count)})?.key ?? .failed
    }
    
    static func toModels() -> [CriteriaModel] {
        table
            .sorted(by: { $0.key < $1.key})
            .map { grade, range in
                var description: String
                switch grade {
                case .elite: description = "\(range.upperBound.formatted(.time(pattern: .minuteSecond))) 이하"
                case .failed: description = "\(range.lowerBound.formatted(.time(pattern: .minuteSecond))) 이상"
                default: description = "\(range.lowerBound.formatted(.time(pattern: .minuteSecond))) ~ \(range.upperBound.formatted(.time(pattern: .minuteSecond)))"
                }
                
                return CriteriaModel(grade: grade, description: description)
            }
    }
}
