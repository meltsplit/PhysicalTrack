//
//  UserInfoFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import ComposableArchitecture

@Reducer
struct UserInfoFeature {
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            return .none
        }
        
    }
    
}
