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
    struct State: Equatable {
        var isTimerRunning = false
        fileprivate var leftSeconds: Int = 2 //TODO: 120으로 변경
        var leftTime: String { leftSeconds.to_mmss }
        var count: Int = 0
        var presentResult: Bool = false

    }
    
    enum Action {
        case onAppear
        case timerTick
        case counting
        case quitButtonTapped
        case selectCount(Int)
        case doneButtonTapped
    }
    
    enum CancelID { case timer}
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                
                state.isTimerRunning = true
                guard state.isTimerRunning 
                else { return .cancel(id: CancelID.timer ) }
                
                return .run { send in
                    while true {
                        try await Task.sleep(for: .seconds(1))
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.timer)
                    
                
            case .timerTick:
                
                guard state.leftSeconds > 0
                else {
                    state.presentResult = true
                    return .cancel(id: CancelID.timer)
                                   }
                
                state.leftSeconds -= 1
                return .none
            case .counting:
                state.count += 1
                return .none
            
            case .quitButtonTapped:
                return .run { _ in await self.dismiss() }
            case .selectCount(let count):
                state.count = count
                return .none
            case .doneButtonTapped:
                return .none
            }
        }
    }
    
}


