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
    
    enum Policy {
        static let totalDistance = 3000
        static let unitDistance = 100
    }
    
    @ObservableState
    struct State: Equatable {
        var locations: [Location] = []
        var currentSeconds: Int = 0
        // m단위
        var totalDistance: Double = 0.0
        
        // 3km를 100m로 나누면 구간 30개가 나온다.
        // seconds 기준으로 기록된다.
        var timeIntervals: [TimeInterval] = Array(repeating: 0, count: Policy.totalDistance / Policy.unitDistance)
        
        var isMute: Bool = false
        var readyLeftSeconds: Int = 3
        var path = StackState<WorkoutResultFeature.State>()
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case ready
        case start
        case pause
        case finish
        case timerTick
        case readyTimerTick
        case locationUpdated(Location)
        case muteButtonTapped
        case pauseButtonTapped
        case path(StackAction<WorkoutResultFeature.State, WorkoutResultFeature.Action>)
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
                return .send(.ready)
            case .ready:
                state.readyLeftSeconds = 3
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.readyTimerTick)
                    }
                }.cancellable(id: CancelID.ready)
                
            case .readyTimerTick:
                guard state.readyLeftSeconds > 0
                else { return .merge(.cancel(id: CancelID.ready), .send(.start)) }
                
                state.readyLeftSeconds -= 1
                return .none
            case .start:
                return .merge(
                    .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTick)
                        }
                    },
                    .run { send in
                        for try await clLocation in liveUpdates() {
                            guard let location: Location = try? clLocation.toDomain()
                            else { return }
                            await send(.locationUpdated(location))
                        }
                    }
                ).cancellable(id: CancelID.running)
            case .timerTick:
                state.currentSeconds += 1
                return .none
            case .locationUpdated(let newValue):
                guard let latestValue = state.locations.last else {
                    state.locations.append(newValue)
                    return .none
                }
                state.locations.append(newValue)
                let distance = newValue.distance(latestValue)
                let timeInterval = newValue.timestamp.timeIntervalSince(latestValue.timestamp)
                state.totalDistance += distance
                var index = Int(state.totalDistance) / Policy.unitDistance
                index = min(index, state.timeIntervals.count - 1)
                state.timeIntervals[index] += timeInterval
                
                if index == state.timeIntervals.count - 1 {
                    return .run { send in await send(.finish) }
                }
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
                print("수고했어")
                return .none
            case .path(.element(id: _, action: .goStatisticsButtonTapped)):
                return .run { _ in await dismiss() }
            case .path:
                return .none
            case .muteButtonTapped:
                state.isMute.toggle()
                return .none
            case.alert(.presented(.quit)):
                return .run { _ in await dismiss() }
            case .alert(.presented(.resume)):
                return .send(.ready)
            case .alert:
                return .none
            }
        
        }
        .forEach(\.path, action: \.path) {
            WorkoutResultFeature()
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

