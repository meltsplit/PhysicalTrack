//
//  WorkoutReadyFeature.swift
//  PhysicalTrack
//
//  Created by MELT on 6/9/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WorkoutReadyFeature {
    
    @ObservableState
    struct State: Equatable {
        var readyLeftSeconds: Int = 3
    }
    
    enum Action {
        case onAppear
        case tick
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
                        await send(.tick)
                    }
                }.cancellable(id: CancelID.ready)
            case .tick:
                if state.readyLeftSeconds > 0 {
                    state.readyLeftSeconds -= 1
                    return .none
                } else {
                    return .send(.finished)
                }
            case .finished:
                return .cancel(id: CancelID.ready)
            }
        }
    }
}
