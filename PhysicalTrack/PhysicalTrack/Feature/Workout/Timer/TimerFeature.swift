//
//  TimerStore.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture
import UIKit

@Reducer
struct TimerFeature {
    
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State {
        var record: PushUpRecord
        var isTimerRunning = false
        fileprivate var leftSeconds: Int = 120
        var leftTime: String { leftSeconds.to_mmss }
        var presentResult: Bool = false
        var path = StackState<WorkoutResultFeature.State>()
        
        init(_ record: PushUpRecord) {
            self.record = record
        }
    }
    
    enum Action {
        case onAppear
        case timerTick
        case detected
        case quitButtonTapped
        case selectCount(Int)
        case path(StackAction<WorkoutResultFeature.State, WorkoutResultFeature.Action>)
    }
    
    enum CancelID { case timer }
    
    @Dependency(\.proximityClient) var proximityClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.leftSeconds = state.record.targetSeconds
                state.isTimerRunning = true
                guard state.isTimerRunning
                else { return .cancel(id: CancelID.timer ) }
                
                return .merge(
                    .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }.cancellable(id: CancelID.timer),
                    .run { send in
                        do {
                            for try await detected in proximityClient.start() {
                                if detected {
                                    await send(.detected)
                                }
                            }
                        } catch {
                            await send(.quitButtonTapped)
                        }
                    })
                
                
            case .timerTick:
                
                guard state.leftSeconds > 0
                else {
                    state.presentResult = true
                    return .cancel(id: CancelID.timer)
                }
                state.record.time = state.record.targetSeconds - state.leftSeconds
                state.leftSeconds -= 1
                return .none
                
            case .detected:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                state.record.count += 1
                
                return .none
                
            case .quitButtonTapped:
                return .run { _ in await self.dismiss() }
            case .selectCount(let count):
                state.record.count = count
                return .none
            case .path(.element(id: _, action: .goStatisticsButtonTapped)):
                return .run { _ in return await dismiss()}
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            WorkoutResultFeature()
        }
    }
    
}


