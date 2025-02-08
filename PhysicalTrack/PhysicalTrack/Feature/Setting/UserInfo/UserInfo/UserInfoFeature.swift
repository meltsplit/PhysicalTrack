//
//  UserInfoFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import ComposableArchitecture

@Reducer
struct UserInfoFeature {
    
    @Reducer(state: .equatable)
    enum Destination {
        case editNickname(EditUserInfoFeature)
        case editGender(EditUserInfoFeature)
        case editBirth(EditUserInfoFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var userInfo: UserInfo = .init(name: "", gender: .male, yearOfBirth: 2000)
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        // View
        case onAppear
        case editNicknameButtonTapped
        case editGenderButtonTapped
        case editBirthButtonTapped
        case withdrawButtonTapped
        
        // Effect
        case userInfoResponse(Result<UserInfo, Error>)
        case withdrawResponse(Result<Void, Error>)
        
        // Navigation
        case destination(PresentationAction<Destination.Action>)
        
        case delegate(Delegate)
        
        enum Delegate {
            case withdrawCompleted
        }
    }
    
    @Dependency(\.userClient.fetch) private var fetch
    @Dependency(\.userClient.withdraw) private var withdraw
    @Dependency(\.defaultAppStorage) private var appStorage
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                // View
            case .onAppear:
                return .run { send in
                    let result = await Result { try await fetch() }
                    await send(.userInfoResponse(result))
                }
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
                return .run { send in
                    let result = await Result { try await withdraw() }
                    await send(.withdrawResponse(result))
                }
                
                // Effect
            case .userInfoResponse(.success(let dto)):
                state.userInfo = dto
                return .none
                
            case .userInfoResponse(.failure(_)):
                return .none
                
            case .withdrawResponse(.success):
                PTAppStorageKey.allCases.forEach {
                    appStorage.removeObject(forKey: $0.rawValue)
                }
                return .send(.delegate(.withdrawCompleted))
            case .withdrawResponse(.failure):
                return .none
                
            // Navigation
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
                
            // Delegate
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
    }
    
}
