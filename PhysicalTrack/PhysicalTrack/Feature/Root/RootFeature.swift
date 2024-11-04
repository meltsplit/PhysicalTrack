//
//  RootFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootFeature {
    
    @ObservableState
    enum State {
        case onboarding(OnboardingFeature.State)
        case main(MainFeature.State)
        
        init() {
            self = .onboarding(.init())
        }
    }
    
    enum Action {
        case onAppear
        case signInResponse(Result<Void,Error>)
        
        case onboarding(OnboardingFeature.Action)
        case main(MainFeature.Action)
    }
    
    @Dependency(\.authClient) var authClient
    @Dependency(\.appClient) var appClient
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                return .run { send in
                    let deviceID = await appClient.deviceID()
//                    let deviceID = UUID().uuidString
                    let request = SignInRequest(deviceId: deviceID)
                    await send(.signInResponse(Result { try await authClient.signIn(request: request) }))
                }
            case .signInResponse(.success(_)):
                state = .main(.init())
                return .none
            case .signInResponse(.failure(_)):
                state = .onboarding(.init())
                return .none
            case .onboarding(.signUpResponse(.success(_))):
                state = .main(.init())
                return .none
            case .onboarding, .main:
                return .none
            
            }
        
        }
        .ifCaseLet(\.onboarding, action: \.onboarding) {
            OnboardingFeature()
        }
        .ifCaseLet(\.main, action: \.main) {
            MainFeature()
        }
    }
}
