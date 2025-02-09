//
//  RunningFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/9/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct RunningFeature {
    
    struct State: Equatable {
        var showAuthorizationAlert: Bool = false
        var distance: [LocationUpdate] = []
        var totalDistance: Double
    }
    
    enum Action {
        case onAppear
        case tapped
        case start
        case done
        case locationUpdated(LocationUpdate)
        case requestAuthorization
    }
    
    @Dependency(\.locationClient) var locationClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .tapped:
                return .run { send in
                    let authorization = locationClient.authorizationStatus()
                    guard authorization == .authorizedAlways || authorization == .authorizedWhenInUse
                    else {
                        await send(.requestAuthorization)
                        return
                    }
                    await send(.start)
                }
            case .start:
                return .run { send in
                    let authorization = locationClient.authorizationStatus()
                    guard authorization == .authorizedAlways || authorization == .authorizedWhenInUse
                    else { await send(.requestAuthorization); return }
                    for try await location in locationClient.liveUpdates() {
                        await send(.locationUpdated(location.toDomain()))
                    }
                }
            case .done:
                return .none
            case .locationUpdated(let location):
                state.distance.append(location)
                return .none
            case .requestAuthorization:
                return .run { send in
                    locationClient.requestAuthorization()
                    await send(.done)
                }
            }
        }
    }
}

