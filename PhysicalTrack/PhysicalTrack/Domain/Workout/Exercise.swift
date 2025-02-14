//
//  Exercise.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/13/25.
//

import Foundation
import CasePaths

protocol ExerciseIdentifiable {
    var type: Exercise { get }
}

enum Exercise {
    case pushUp
    case running
}

enum Record: Equatable {
    case pushUp(PushUpRecord)
    case running(RunningRecord)

    func evaluate() -> Grade {
        switch self {
        case .running(let record): return record.evaluate()
        case .pushUp(let record): return record.evaluate()
        }
    }

}

extension Record: ExerciseIdentifiable {
    var type: Exercise {
        switch self {
        case .running: .running
        case .pushUp: .pushUp
        }
    }
}


protocol Evaluatable {
    func evaluate() -> Grade
}

struct RunningRecord: Equatable {
    var targetDistance = 3000
    var totalSeconds: Duration
    var speed: Double {
        let hours = Double(totalSeconds.components.seconds) / 60
        let km: Double = Double(targetDistance) / 1000
        return km / hours
    }
    
    init(for grade: Grade) {
        self.totalSeconds = .zero
    }
}

extension RunningRecord: Evaluatable {
    func evaluate() -> Grade {
        Criteria.running.table.first { $0.value.contains(.running(totalSeconds)) }?.key ?? .failed
    }
}

extension RunningRecord: RecordConvertible {
    func asRecord() -> Record {
        return .running(self)
    }
}


struct CriteriaModel: Hashable, Identifiable {
    var id: Self { self }
    let grade: Grade
    let value: ClosedRange<WorkoutValue>
    
    var description: String {
        
        switch type {
        case .pushUp:
            guard value.lowerBound != .pushUp(Int.min)
            else { return "\(value.upperBound.description) 이하" }
    
            guard value.upperBound != .pushUp(Int.max)
            else { return "\(value.lowerBound.description) 이상" }
    
            return "\(value.lowerBound.description) ~ \(value.upperBound.description)"
        case .running:
            let lowerBound = value.lowerBound.description
            let upperBound = value.upperBound.description
    
            if value.lowerBound == .running(.seconds(0)) {
                return "\(upperBound) 이하"
            }
    
            if value.upperBound == .running(.seconds(Int.max)) {
                return "\(lowerBound) 이상"
            }
    
            return "\(lowerBound) ~ \(upperBound)"
        }
    }
}

extension CriteriaModel: ExerciseIdentifiable {
    var type: Exercise {
        switch value.lowerBound {
        case .pushUp: return .pushUp
        case .running: return .running
        }
    }
}

enum Criteria: Equatable {
    case pushUp
    case running
    
    var table: [Grade: ClosedRange<WorkoutValue>] {
        switch self {
        case .pushUp:
            return [
                .elite: .pushUp(72)...(.pushUp(Int.max)),
                .grade1: .pushUp(64)...(.pushUp(71)),
                .grade2: .pushUp(56)...(.pushUp(63)),
                .grade3: .pushUp(48)...(.pushUp(55)),
                .failed: .pushUp(0)...(.pushUp(47))
            ]
        case.running:
            return [
                .elite: .running(.seconds(0))...(.running(.seconds(750))),
                .grade1: .running(.seconds(751))...(.running(.seconds(812))),
                .grade2: .running(.seconds(813))...(.running(.seconds(844))),
                .grade3: .running(.seconds(845))...(.running(.seconds(906))),
                .failed: .running(.seconds(906))...(.running(.seconds(Int.max)))
            ]
        }
    }
    
    var models: [CriteriaModel] {
        Grade.allCases.map { CriteriaModel(grade: $0, value: table[$0]!)}
    }
}





enum WorkoutValue: Comparable, Hashable {
    case pushUp(Int)
    case running(Duration)
    
    var description: String {
        switch self {
        case .pushUp(let value):
            "\(value) 회"
        case .running(let duration):
            duration.formatted(.time(pattern: .minuteSecond))
        }
    }
}

extension Criteria: ExerciseIdentifiable {
    var type: Exercise {
        switch self {
        case .pushUp:
            return .pushUp
        case .running:
            return .running
        }
    }
}


protocol RecordConvertible {
    func asRecord() -> Record
}

struct RecordFactory {
    static func makeRecord(_ type: Exercise, _ grade: Grade) -> RecordConvertible {
        switch type {
        case .pushUp: PushUpRecord(for: grade)
        case .running: RunningRecord(for: grade)
        }
    }
}

struct CriteriaFactory {
    
    static func create(for data: ExerciseIdentifiable) -> Criteria {
        switch data.type {
        case .pushUp:
            return .pushUp
        case .running:
            return .running
        }
    }
}

//
//protocol AbstractExerciseFactory {
//    func makeRecord(_ grade: Grade) -> RecordConvertible
//    func makeCriteria() -> Criteria
//}
//
//
//struct PushUpFactory: AbstractExerciseFactory {
//    func makeRecord(_ grade: Grade) -> RecordConvertible {
//        PushUpRecord(for: grade)
//    }
//    
//    func makeCriteria() -> Criteria {
//        return .pushUp
//    }
//}
//
//struct RunningFactory: AbstractExerciseFactory {
//    func makeRecord(_ grade: Grade) -> RecordConvertible {
//        RunningRecord(for: grade)
//    }
//    
//    func makeCriteria() -> Criteria {
//        return .running
//    }
//}


