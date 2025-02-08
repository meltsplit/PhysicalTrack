//
//  EditUserInfoFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import ComposableArchitecture

@Reducer
struct EditUserInfoFeature {
    
    @ObservableState
    struct State: Equatable {
        var userInfo: UserInfo
        var isLoading: Bool = false
        
        init(userInfo: UserInfo) {
            self.userInfo = userInfo
        }
        @Shared(.appStorage(key: .username)) var username = ""
    }
    
    enum Action {
        case nameChanged(String)
        case genderChanged(Gender)
        case yearOfBirthChanged(Int)
        
        case doneButtonTapped
        case updateResponse(Result<Void, Error>)
        case delegate(Delegate)
        
        enum Delegate {
            case updateCompleted(UserInfo)
        }
    }
    
    @Dependency(\.userClient.update) var update
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
            case .nameChanged(let name):
                state.userInfo.name = name
                return .none
            case .genderChanged(let gender):
                state.userInfo.gender = gender
                return .none
            case .yearOfBirthChanged(let birth):
                state.userInfo.yearOfBirth = birth
                return .none
            case .doneButtonTapped:
                state.isLoading = true
                return .run { [state] send in
                    let result = await Result { try await update(state.userInfo) }
                    await send(.updateResponse(result))
                }
            case .updateResponse(.success):
                state.$username.withLock { $0 = state.userInfo.name }
                return .concatenate(
                    .send(.delegate(.updateCompleted(state.userInfo))),
                    .run { _ in await dismiss() }
                )
            case .updateResponse(.failure(_)):
                state.isLoading = false
                return .none
            case .delegate:
                return .none
            }
            
        }
        
    }
    
}
