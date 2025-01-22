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
        var userInfo: UserInfo = .init(name: "", gender: .male, yearOfBirth: 2000)
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case onAppear
        case userInfoResponse(Result<UserInfoResponse, Error>)
        case editNicknameButtonTapped
        case editGenderButtonTapped
        case editBirthButtonTapped
        case withdrawButtonTapped
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Reducer
    enum Destination {
        case editNickname(EditUserInfoFeature)
        case editGender(EditUserInfoFeature)
        case editBirth(EditUserInfoFeature)
    }
    
    @Dependency(\.userClient.fetchUserInfo) private var fetch
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let result = await Result { try await fetch() }
                    await send(.userInfoResponse(result))
                }
            case .userInfoResponse(.success(let dto)):
                state.userInfo = dto.toDomain()
                return .none
                
            case .userInfoResponse(.failure(_)):
                return .none
            case .editNicknameButtonTapped:
                state.destination = .editNickname(.init(userInfo: state.userInfo))
                return .none
            case .editGenderButtonTapped:
                state.destination = .editGender(.init(userInfo: state.userInfo))
                return .none
            case .editBirthButtonTapped:
                state.destination = .editBirth(.init(userInfo: state.userInfo))
                return .none
            case .withdrawButtonTapped:
                return .none
            case .destination(.presented(.editNickname(.delegate(.updateCompleted(let userInfo))))):
                state.userInfo = userInfo
                return .none
            case .destination(.presented(.editBirth(.delegate(.updateCompleted(let userInfo))))):
                state.userInfo = userInfo
                return .none
                
            case .destination(.presented(.editGender(.delegate(.updateCompleted(let userInfo))))):
                state.userInfo = userInfo
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
    }
    
}
