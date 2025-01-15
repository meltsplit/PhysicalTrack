//
//  EditNicknameFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import ComposableArchitecture

@Reducer
struct EditNicknameFeature {
    
    @ObservableState
    struct State: Equatable {
        var name: String = "홍길동"
    }
    
    enum Action {
        case nameChanged(String)
        case doneButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
            case .nameChanged(let name):
                state.name = name
                return .none
            case .doneButtonTapped:
                return .none
            }
        }
        
    }
    
}
