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
        @Shared(.appStorage(key: .username)) var username = "회원"
        @Shared(.appStorage(key: .shouldShowTutorial)) var shouldShowTutorial = true
        @Presents var tutorial: TutorialFeature.State?
        @Presents var timer: TimerFeature.State?
    }
    
    enum Action {
        case gradeChanged(Grade)
        case startButtonTapped
        case tutorial(PresentationAction<TutorialFeature.Action>)
        case timer(PresentationAction<TimerFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .gradeChanged(grade):
                state.grade = grade
                return .none
                
            case .startButtonTapped:
                if state.shouldShowTutorial {
                    state.tutorial = TutorialFeature.State()
                } else {
                    state.timer = TimerFeature.State(PushUpRecord(for: state.grade))
                }
                return .none
                
            case .tutorial(.presented(.confirmButtonTapped)):
                state.shouldShowTutorial = false
                state.timer = TimerFeature.State(PushUpRecord(for: state.grade))
                return .none
            case .tutorial:
                return .none
            case .timer:
                return .none
            }
        }
        .ifLet(\.$tutorial, action: \.tutorial) {
            TutorialFeature()
        }
        .ifLet(\.$timer, action: \.timer) {
            TimerFeature()
        }
    }

}


