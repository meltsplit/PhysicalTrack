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
        @Presents var running: RunningFeature.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case gradeChanged(Grade)
        case startButtonTapped
        case startRunningButtonTapped
        case tutorial(PresentationAction<TutorialFeature.Action>)
        case timer(PresentationAction<TimerFeature.Action>)
        case running(PresentationAction<RunningFeature.Action>)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case confirm
            case cancel
        }
    }
    
    @Dependency(\.locationClient.authorizationStatus) var locationAuthorizationStatus
    @Dependency(\.locationClient.requestAuthorization) var requestLocationAuthorization
    @Dependency(\.openSettings) var openSettings
    
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
            case .startRunningButtonTapped:
                let status = locationAuthorizationStatus()
                switch status {
                case .notDetermined:
                    requestLocationAuthorization()
                    return .none
                case .authorized:
                    state.running = RunningFeature.State()
                    return .none
                case .unauthorized:
                    state.alert = AlertState(
                        title: { TextState("설정에서 위치 권한을 허용해주세요.") },
                        actions: {
                            
                            ButtonState(action: .cancel) {
                                TextState("취소")
                            }

                            ButtonState(action: .confirm) {
                                TextState("확인")
                            }
                            
                        },
                        message: { TextState("\n위치 기반 달리기 기능을 제공하기 위해 위치정보가 필요합니다.\n") }
                    )
                    return .none
                }
                
            case .tutorial(.presented(.confirmButtonTapped)):
                state.$shouldShowTutorial.withLock { $0 = false } 
                state.timer = TimerFeature.State(PushUpRecord(for: state.grade))
                return .none
            case .tutorial:
                return .none
            case .timer:
                return .none
            case .running:
                return .none
            case .alert(.presented(.confirm)):
                return .run { _ in
                    await openSettings()
                }
            case .alert(.presented(.cancel)):
                return .none
            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$tutorial, action: \.tutorial) {
            TutorialFeature()
        }
        .ifLet(\.$timer, action: \.timer) {
            TimerFeature()
        }
        .ifLet(\.$running, action: \.running) {
            RunningFeature()
        }
        .ifLet(\.$alert, action: \.alert)
        
    }

}


