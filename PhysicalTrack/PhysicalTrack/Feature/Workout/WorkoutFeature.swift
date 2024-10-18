//
//  WorkoutStore.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

import ComposableArchitecture

enum WorkoutGrade: Equatable {
    case elite
    case grade1
    case grade2
    case grade3
    case failed
    
    var title: String {
        switch self {
        case .elite:
            "특급"
        case .grade1:
            "1급"
        case .grade2:
            "2급"
        case .grade3:
            "3급"
        case .failed:
            "불합격"
        }
    }
    
}

protocol Workout: Equatable {
    var grade: WorkoutGrade { get set }
    var count: ClosedRange<Int> { get }
    
}

struct PushUp: Equatable {
    
    static func getCount(_ grade: WorkoutGrade) -> ClosedRange<Int> {
        switch grade {
        case .elite:
            72...1000
        case .grade1:
            64...71
        case .grade2:
            56...63
        case .grade3:
            48...55
        case .failed:
            0...47
        }
    }
    
    
    
}

@Reducer
struct WorkoutFeature {
    
    @ObservableState
    struct State: Equatable {
        var grade: WorkoutGrade = .grade2
        var count: ClosedRange<Int> = PushUp.getCount(.grade2)
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
                state.timer = TimerFeature.State()
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


