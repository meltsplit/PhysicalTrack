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
        var step: SelectStep = .workout
        var selectedExercise: Exercise = .pushUp
        var grades: [Grade] = Grade.allCases.filter { $0 != .failed }
        var grade: Grade = .elite
        @Shared(.appStorage(key: .username)) var username = "회원"
        @Shared(.appStorage(key: .shouldShowTutorial)) var shouldShowTutorial = true
        @Presents var tutorial: TutorialFeature.State?
        @Presents var pushUp: PushUpFeature.State?
        @Presents var running: RunningFeature.State?
        @Presents var alert: AlertState<Action.Alert>?
        
        enum SelectStep {
            case workout
            case grade
        }
    }
    
    enum Action {
        case exerciseChanged(Exercise)
        case gradeChanged(Grade)
        case resetButtonTapped
        case startButtonTapped
        case startRunning
        case startPushUp
        case tutorial(PresentationAction<TutorialFeature.Action>)
        case pushUp(PresentationAction<PushUpFeature.Action>)
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
            case .exerciseChanged(let newValue):
                state.selectedExercise = newValue
                return .none
            case let .gradeChanged(grade):
                state.grade = grade
                return .none
            case .resetButtonTapped:
                state.step = .workout
                return .none
            case .startButtonTapped:
                switch state.step {
                case .workout:
                    state.step = .grade
                    return .none
                case .grade:
                    switch state.selectedExercise {
                    case .pushUp: return .send(.startPushUp)
                    case .running: return .send(.startRunning)
                    }
                }
            case .startPushUp:
                if state.shouldShowTutorial {
                    state.tutorial = TutorialFeature.State()
                } else {
                    state.pushUp = PushUpFeature.State(PushUpRecord(for: state.grade))
                }
                return .none
            case .startRunning:
                let status = locationAuthorizationStatus()
                switch status {
                case .notDetermined:
                    requestLocationAuthorization()
                    return .none
                case .authorized:
                    state.running = RunningFeature.State(record: .init(for: state.grade))
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
                state.pushUp = PushUpFeature.State(PushUpRecord(for: state.grade))
                return .none
            case .tutorial:
                return .none
            case .pushUp:
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
        .ifLet(\.$pushUp, action: \.pushUp) {
            PushUpFeature()
                .dependency(\.continuousClock, ImmediateClock())
        }
        .ifLet(\.$running, action: \.running) {
            RunningFeature()
                .dependency(\.locationClient, .previewValue)
                
        }
        .ifLet(\.$alert, action: \.alert)
        
    }

}


