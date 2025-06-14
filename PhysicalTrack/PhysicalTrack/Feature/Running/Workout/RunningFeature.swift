//
//  RunningFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/9/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct RunningFeature {
    
    @ObservableState
    struct State: Equatable {
        @Shared(.selectedMainScene) var selectedTab: MainScene = .workout
        var record: RunningRecord
        var ready: WorkoutReadyFeature.State?
        var path = StackState<RunningResultFeature.State>()
        @Presents var alert: AlertState<Action.Alert>?
        
        init(record: RunningRecord) {
            self.record = record
        }
    }
    
    enum Action {
        case onAppear
        case ready(WorkoutReadyFeature.Action)
        case start
        case pause
        case finish
        case timerTick
        case locationUpdated(Location)
        case updateTimeInterval(Array.Index, TimeInterval)
        case pauseButtonTapped
        case path(StackAction<RunningResultFeature.State, RunningResultFeature.Action>)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert {
            case quit
            case resume
        }
    }
    
    enum CancelID {
        case ready
        case running
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.locationClient.liveUpdates) var liveUpdates
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
                    .run { send in
                        for try await location in liveUpdates() {
                            await send(.locationUpdated(location))
                        }
                    }
                ).cancellable(id: CancelID.running)
            case .timerTick:
                state.record.currentDuration += .seconds(1)
                return .none
            case .locationUpdated(let newValue):
                guard let latestValue = state.record.locations.last else {
                    state.record.locations.append(newValue)
                    return .none
                }
                
                state.record.locations.append(newValue)
                let distance = newValue.distance(latestValue)
                state.record.currentDistance += distance
                let timeInterval = newValue.timestamp.timeIntervalSince(latestValue.timestamp)
                let index = Int(state.record.currentDistance) / RunningPolicy.unitDistance
                return .send(.updateTimeInterval(index, timeInterval))
            case let .updateTimeInterval(index, timeInterval):
                let safeIndex = min(index, state.record.timeIntervals.count - 1)
                state.record.timeIntervals[safeIndex] += timeInterval
                guard index < state.record.timeIntervals.count
                else { return .send(.finish) }
                return .none
                
            case .pause:
                return .cancel(id: CancelID.running)
          
            case .pauseButtonTapped:
                state.alert = AlertState(
                    title: { TextState("운동을 종료하시겠습니까?") },
                    actions: {
                        
                        ButtonState(action: .quit) {
                            TextState("종료")
                        }
                        
                        ButtonState(action: .resume) {
                            TextState("재개")
                        }
                        
                    },
                    message: { TextState("수행한 운동은 저장되지 않습니다") }
                )
                return .send(.pause)
            case .finish:
                let runningResult = RunningResultFeature.State(record: state.record)
                state.path.append(runningResult)
                return .cancel(id: CancelID.running)
            case .path(.element(id: _, action: .result(.goStatisticsButtonTapped))):
                state.$selectedTab.withLock { $0 = .statistics }
                return .run { _ in await dismiss() }
            case .path:
                return .none
            case.alert(.presented(.quit)):
                return .run { _ in await dismiss() }
            case .alert(.presented(.resume)):
                state.ready = WorkoutReadyFeature.State()
                return .none
            case .alert:
                return .none
            }
        
        }
        .forEach(\.path, action: \.path) {
            RunningResultFeature()
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.ready, action: \.ready) {
            WorkoutReadyFeature()
        }
    }
}

