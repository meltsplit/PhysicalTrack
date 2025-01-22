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
        var name: String = "11"
        var gender: Gender = .female
        var yearOfBirth: Int = 2220
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case onAppear
        case fetchUserInfo(Result<UserInfoResponse, Error>)
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
    
    @Dependency(\.userClient.fetchUserInfo) private var fetchUserInfo
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let result = await Result { try await fetchUserInfo() }
                    await send(.fetchUserInfo(result))
                }
            case .fetchUserInfo(.success(let dto)):
                state.name = dto.name
                state.gender = dto.gender
                state.yearOfBirth = dto.birthYear
                return .none
                
            case .fetchUserInfo(.failure(let error)):
                return .none
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
