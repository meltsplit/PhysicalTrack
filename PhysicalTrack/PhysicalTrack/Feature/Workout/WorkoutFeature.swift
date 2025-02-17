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
        var phase: Phase = Phase()
        var selectedExercise: Exercise = .pushUp
        var grades: [Grade] = Grade.allCases.filter { $0 != .failed }
        var grade: Grade = .elite
        var description: CriteriaDescription = .init(description: "", highlight: "")
        @Shared(.appStorage(key: .username)) var username = "회원"
        @Shared(.appStorage(key: .shouldShowTutorial)) var shouldShowTutorial = true
        @Presents var tutorial: TutorialFeature.State?
        @Presents var pushUp: PushUpFeature.State?
        @Presents var running: RunningFeature.State?
        @Presents var alert: AlertState<Action.Alert>?
        
        enum Phase {
            case selectWorkout
            case selectGrade
            
            init() {
                self = .selectWorkout
            }
        }
    }
    
    enum Action {
        case onAppear
        case exerciseChanged(Exercise)
        case gradeChanged(Grade)
        case changeDescription
        case resetButtonTapped
        case doneButtonTapped
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
            case .onAppear:
                return .send(.changeDescription)
            case .exerciseChanged(let newValue):
                state.selectedExercise = newValue
                return .send(.changeDescription)
            case .gradeChanged(let newValue):
                state.grade = newValue
                return .send(.changeDescription)
            case .changeDescription:
                switch state.selectedExercise {
                case .pushUp:
                    state.description = PushUpCriteria.toDescription(for: state.grade)
                case .running:
                    state.description = RunningCriteria.toDescription(for: state.grade)
                }
                return .none
            case .resetButtonTapped:
                state.phase = .selectWorkout
                return .none
            case .doneButtonTapped:
                switch state.phase {
                case .selectWorkout:
                    state.phase = .selectGrade
                    return .none
                case .selectGrade:
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


