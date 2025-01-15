//
//  EditBirthFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import ComposableArchitecture

@Reducer
struct EditBirthFeature {
    
    @ObservableState
    struct State: Equatable {
        var yearOfBirth: Int = 2000
    }
    
    enum Action {
        case yearOfBirthChanged(Int)
        case doneButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
            case .yearOfBirthChanged(let yearOfBirth):
                state.yearOfBirth = yearOfBirth
                return .none
            case .doneButtonTapped:
                return .none
            }
        }
        
    }
    
}

