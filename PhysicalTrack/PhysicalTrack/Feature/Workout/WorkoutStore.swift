//
//  WorkoutStore.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

import ComposableArchitecture
enum WorkoutGrade {
    case elite
    case grade1
    case grade2
    case grade3
    case failed
}

@Reducer
struct WorkoutStore {
    
    @ObservableState
    struct State: Equatable {
        let grade: WorkoutGrade
        let time: Date
        let count: Int
    }
    
    enum Action {
        case gradeButtonTapped
        case timeButtonTapped
        case countButtonTapped
        case startButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .gradeButtonTapped:
                return .none
            case .timeButtonTapped:
                return .none
            case .countButtonTapped:
                return .none
            case .startButtonTapped:
                return .none
            }
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


