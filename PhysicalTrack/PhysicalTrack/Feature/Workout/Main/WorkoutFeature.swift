//
//  WorkoutStore.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

import ComposableArchitecture


@Reducer
struct WorkoutFeature {
    
    @ObservableState
    struct State: Equatable {
        var grade: WorkoutGrade = .grade2
        var count: ClosedRange<Int> { PushUp.getValue(grade) }
        @Presents var timer: TimerFeature.State?
    }
    
    enum Action {
        case gradeButtonTapped
        case startButtonTapped
        case timer(PresentationAction<TimerFeature.Action>)
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .gradeButtonTapped:
                return .none
                
            case .startButtonTapped:
                state.timer = TimerFeature.State(PushUpRecord(for: .grade1))
                return .none
                
                
            case .timer:
                return .none
            }
        }
        .ifLet(\.$timer, action: \.timer) {
            TimerFeature()
        }
     
    }
    
    //    var body: some ReducerOf<Self> {
    //        Reduce { state, action in
    //            switch action {
    //            case .decrementButtonTapped:
    //                state.count -= 1
    //                state.fact = nil
    //                return .none
    //
    //            case .factButtonTapped:
    //                state.fact = nil
    //                state.isLoading = true
    //
    //                return .run { [count = state.count] send in
    //                    let (data, _) = try await URLSession.shared
    //                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
    //                    let fact = String(decoding: data, as: UTF8.self)
    //                    await send(.factResponse(fact))
    //                }
    //            case let .factResponse(fact):
    //                state.fact = fact
    //                state.isLoading = false
    //                return .none
    //
    //            case .increaseButtonTapped:
    //                state.count += 1
    //                state.fact = nil
    //                return .none
    //
    //
    //            case .timerTick:
    //                state.count += 1
    //                state.fact = nil
    //                return .none
    //
    //            case .toggleTimerButtonTapped:
    //                state.isTimerRunning.toggle()
    //                if state.isTimerRunning {
    //                    return .run { send in
    //                        while true {
    //                            try await Task.sleep(for: .seconds(1))
    //                            await send(.timerTick)
    //                        }
    //                    }
    //                    .cancellable(id: CancelID.timer)
    //
    //                } else {
    //                    return .cancel(id: CancelID.timer)
    //                }
    //
    //            }
    //        }
    //    }
    
    
}


