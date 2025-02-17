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
        .failed: .seconds(907)...(.seconds(Int.max))
    ]
}

extension RunningCriteria {
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
    
    static func toDescription(for grade: Grade) -> CriteriaDescription {
        guard grade != .failed,
              let maxDuration = table[grade]?.upperBound
        else { return CriteriaDescription(
            description: "3km를 15분 6초 안에 완주하지 못하면 불합격입니다.",
            highlight: "15분 6초"
        ) }
        
        let totalSeconds = Int(maxDuration.components.seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return CriteriaDescription(
            description: "3km를 \(minutes)분 \(seconds)초 내로 완주해야 합니다.",
            highlight: "\(minutes)분 \(seconds)초"
        )
    }
}
