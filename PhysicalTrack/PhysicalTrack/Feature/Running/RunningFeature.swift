//
//  RunningFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/9/25.
//

import ComposableArchitecture

@Reducer
struct RunningFeature {
    
    @ObservableState
    struct State: Equatable {
        var distance: [LocationUpdate] = []
        var totalDistance: Double = 0.0
    }
    
    enum Action: Equatable {
        case onAppear
        case start
        case locationUpdated(LocationUpdate)
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
                    for try await location in liveUpdates() {
                        await send(.locationUpdated(location.toDomain()))
                    }
                }
            case .locationUpdated(let location):
                state.distance.append(location)
                return .none
            }
        }
    }
}

