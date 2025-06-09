//
//  PushUpFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture


@Reducer
struct PushUpFeature {
    
    @ObservableState
    struct State: Equatable {
        var record: PushUpRecord
        var isMute: Bool = false
        fileprivate var currentWorkoutSeconds: Int { Int(record.duration.components.seconds) - workoutLeftSeconds}
        var ready: WorkoutReadyFeature.State?
        var workoutLeftSeconds: Int
        var presentResult: Bool = false
        var path = StackState<WorkoutResultFeature.State>()
        @Presents var alert: AlertState<Action.Alert>?
        
        init(_ record: PushUpRecord) {
            self.record = record
            self.workoutLeftSeconds = Int(record.duration.components.seconds)
        }
    }
    
    enum Action {
        case onAppear
        case ready(WorkoutReadyFeature.Action)
        case start
        case timerTick
        case targetTimerTick
        case pause
        case finish
        case detected
        case muteButtonTapped
        case quitButtonTapped
        case selectCount(Int)
        case doneButtonTapped
        case path(StackAction<WorkoutResultFeature.State, WorkoutResultFeature.Action>)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert {
            case quit
            case resume
        }
    }
    
    enum CancelID {
        case workout
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.proximityClient) var proximityClient
    @Dependency(\.audioClient) var audioClient
    @Dependency(\.hapticClient) var hapticClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.ready = WorkoutReadyFeature.State()
                return .none
            case .ready(.finished):
                state.ready = nil
                return .send(.start)
            case .ready:
                return .none
                
            case .start:
                return .merge(
                    .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTick)
                        }
                    },
                    .run { [state] send in
                        let interval = state.record.duration / Double(state.record.targetCount)
                        for await _ in self.clock.timer(interval: interval) {
                            await send(.targetTimerTick)
                        }
                    },
                    .run { send in
                        for await detected in await proximityClient.start() {
                            if detected { await send(.detected) }
                        }
                    }
                ).cancellable(id: CancelID.workout)
                
            case .timerTick:
                guard state.workoutLeftSeconds > 0
                else { return .send(.finish) }
                
                state.workoutLeftSeconds -= 1
                return .none
            case .targetTimerTick:
                guard !state.isMute else { return .none }
                audioClient.play()
                return .none
                
            case .pause:
                return .merge(
                    .run { _ in await proximityClient.stop() },
                    .cancel(id: CancelID.workout)
                )
            case .finish:
                state.presentResult = true
                return .send(.pause)
                
            case .detected:
                hapticClient.impact(.heavy)
                state.record.count += 1
                state.record.tempo.append(Double(state.currentWorkoutSeconds))
                return .none
                
            case .muteButtonTapped:
                state.isMute.toggle()
                return .none
            case .quitButtonTapped:
                state.alert = AlertState(
                    title: { TextState("운동을 종료하시겠습니까?") },
                    actions: {
                        
                        ButtonState(action: .quit, label: { TextState("종료") })
                        
                        ButtonState(action: .resume, label: { TextState("재개") })
                        
                    },
                    message: { TextState("수행한 운동은 저장되지 않습니다") }
                )
                return .send(.pause)
                
            case .selectCount(let count):
                state.record.count = count
                return .none
                
            case .doneButtonTapped:
                let workoutResultFeature = WorkoutResultFeature.State.pushUp(.init(record: state.record))
                state.path.append(workoutResultFeature)
                return .none
                
            case.alert(.presented(.quit)):
                return .run { _ in await dismiss() }
                
            case .alert(.presented(.resume)):
                state.ready = WorkoutReadyFeature.State()
                return .none
                
            case .path(.element(id: _, action: .goStatisticsButtonTapped)):
                return .run { _ in await dismiss()}
            case .path:
                return .none
                
            case .alert:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            WorkoutResultFeature()
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.ready, action: \.ready) {
            WorkoutReadyFeature()
        }
    }
    
}


extension PushUpFeature.Action.Alert: Equatable { }

@Reducer
struct WorkoutReadyFeature {
    
    @ObservableState
    struct State: Equatable {
        var readyLeftSeconds: Int = 3
    }
    
    enum Action {
        case onAppear
        case readyTimerTick
        case finished
    }
    
    enum CancelID {
        case ready
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.readyLeftSeconds = 3
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.readyTimerTick)
                    }
                }.cancellable(id: CancelID.ready)
            case .readyTimerTick:
                guard state.readyLeftSeconds > 0
                else { return .send(.finished) }
                
                state.readyLeftSeconds -= 1
                return .none
            case .finished:
                return .cancel(id: CancelID.ready)
            }
        }
    }
}
