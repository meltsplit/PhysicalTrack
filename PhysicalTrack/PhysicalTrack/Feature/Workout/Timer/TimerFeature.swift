//
//  TimerStore.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TimerFeature {
    
    @ObservableState
    struct State {
        var record: PushUpRecord
        var isTimerRunning = false
        fileprivate var _leftSeconds: Int
        var leftTime: String { _leftSeconds.to_mmss }
        var presentResult: Bool = false
        var path = StackState<WorkoutResultFeature.State>()
        @Presents var alert: AlertState<Action.Alert>?
        
        init(_ record: PushUpRecord) {
            self.record = record
            self._leftSeconds = Int(record.duration.components.seconds)
        }
    }
    
    enum Action {
        case onAppear
        case start
        case timerTick
        case pause
        case finish
        case detected
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
    
    enum CancelID { case workout }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.proximityClient) var proximityClient
    @Dependency(\.hapticClient) var hapticClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isTimerRunning = true
                return .send(.start)
                
            case .start:
                return .merge(
                    .run { [isTimerRunning = state.isTimerRunning] send in
                        guard isTimerRunning else { return }
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTick)
                        }
                    },
                    .run { send in
                        for await detected in proximityClient.start() {
                            if detected { await send(.detected) }
                        }
                    }
                ).cancellable(id: CancelID.workout)
                
            case .timerTick:
                
                guard state._leftSeconds > 0
                else { return .send(.finish) }
                
                state._leftSeconds -= 1
                return .none
                
            case .pause:
                proximityClient.stop()
                return .cancel(id: CancelID.workout)
                
            case .finish:
                state.presentResult = true
                proximityClient.stop()
                return .cancel(id: CancelID.workout)
                
            case .detected:
                hapticClient.impact(.heavy)
                state.record.count += 1
                
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
                state.path.append(.init(record: state.record))
                return .none
                
            case.alert(.presented(.quit)):
                return .run { _ in await dismiss() }
                
            case .alert(.presented(.resume)):
                return .send(.start)
                
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
        .ifLet(\.alert, action: \.alert)
    }
    
}


