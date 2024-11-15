//
//  WorkoutStore.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

import ComposableArchitecture


@Reducer
struct WorkoutFeature {
    
    @ObservableState
    struct State: Equatable {
        var grades: [Grade] = Grade.allCases.filter { $0 != .failed }
        var grade: Grade = .grade2
        var criteria: GradeCriteria<PushUp> { GradeCriteria<PushUp>(grade: grade) }
        @Presents var timer: TimerFeature.State?
    }
    
    enum Action {
        case gradeChanged(Grade)
        case startButtonTapped
        case timer(PresentationAction<TimerFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .gradeChanged(grade):
                state.grade = grade
                return .none
                
            case .startButtonTapped:
                state.timer = TimerFeature.State(PushUpRecord(for: state.grade))
                return .none
                
                
            case .timer:
                return .none
            }
        }
        .ifLet(\.$timer, action: \.timer) {
            TimerFeature()
        }
     
    }

}


