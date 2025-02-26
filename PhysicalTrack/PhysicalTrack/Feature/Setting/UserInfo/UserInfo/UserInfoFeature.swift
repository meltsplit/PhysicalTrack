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
        @Shared(.selectedRootScene) var selectedRootScene = .splash
        var userInfo: UserInfo = .init(name: "", gender: .male, yearOfBirth: 2000)
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
                return .none
            case .editGenderButtonTapped:
                return .none
            case .editBirthButtonTapped:
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
                appStorage.dictionaryRepresentation().keys.forEach {
                    appStorage.removeObject(forKey: $0)
                }
                state.$selectedRootScene.withLock { $0 = .splash }
                return .none
            case .withdrawResponse(.failure):
                return .none
                
            // Navigation
//            case .destination(.presented(.editNickname(.delegate(.updateCompleted(let userInfo))))):
//                state.userInfo = userInfo
//                return .none
//            case .destination(.presented(.editBirth(.delegate(.updateCompleted(let userInfo))))):
//                state.userInfo = userInfo
//                return .none
//                
//            case .destination(.presented(.editGender(.delegate(.updateCompleted(let userInfo))))):
//                state.userInfo = userInfo
//                return .none
//            case .destination:
//                return .none
            }
        }
//        .ifLet(\.$destination, action: \.destination)
        
    }
    
}
