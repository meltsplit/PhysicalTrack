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
        
        // m단위
        var totalDistance: Double = 0.0
        
        // 3km를 100m로 나누면 구간 30개가 나온다.
        // seconds 기준으로 기록된다.
        var timeIntervals: [TimeInterval] = Array(repeating: 0, count: Policy.totalDistance / Policy.unitDistance)
    }
    
    enum Action: Equatable {
        case onAppear
        case start
        case finish
        case locationUpdated(Location)
    }
    
    @Dependency(\.locationClient.liveUpdates) var liveUpdates
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.start)
                }
            case .start:
                return .run { send in
                    for try await clLocation in liveUpdates() {
                        guard let location: Location = try? clLocation.toDomain()
                        else { return }
                        await send(.locationUpdated(location))
                    }
                }
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
            case .finish:
                print("수고했어")
                return .none
                
            }
        
        }
    }
}

