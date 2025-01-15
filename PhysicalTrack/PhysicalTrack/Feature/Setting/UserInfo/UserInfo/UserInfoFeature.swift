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
    struct State {
        var name: String = "홍길동"
        var gender: Gender = .male
        var yearOfBirth: Int = 2000
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case editNicknameButtonTapped
        case editGenderButtonTapped
        case editBirthButtonTapped
        case withdrawButtonTapped
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Reducer
    enum Destination {
        case editNickname(EditNicknameFeature)
        case editGender(EditGenderFeature)
        case editBirth(EditBirthFeature)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editNicknameButtonTapped:
                state.destination = .editNickname(.init())
                return .none
            case .editGenderButtonTapped:
                state.destination = .editGender(.init())
                return .none
            case .editBirthButtonTapped:
                state.destination = .editBirth(.init())
                return .none
            case .withdrawButtonTapped:
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
    }
    
}
