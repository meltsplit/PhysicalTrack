//
//  EditGenderFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import ComposableArchitecture

@Reducer
struct EditGenderFeature {
    
    @ObservableState
    struct State: Equatable {
        var gender: Gender = .male
    }
    
    enum Action {
        case genderChanged(Gender)
        case doneButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
            case .genderChanged(let gender):
                state.gender = gender
                return .none
            case .doneButtonTapped:
                return .none
            }
        }
        
    }
    
}

