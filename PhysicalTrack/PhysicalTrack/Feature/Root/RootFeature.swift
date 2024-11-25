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
        case splash
        case onboarding(OnboardingFeature.State)
        case main(MainFeature.State)
        
        init() {
            self = .splash
        }
    }
    
    enum Action {
        case onAppear
        case signInResponse(Result<String, Error>)
        
        case onboarding(OnboardingFeature.Action)
        case main(MainFeature.Action)
    }
    
    @Shared(.appStorage(key: .accessToken)) var accessToken: String = ""
    @Shared(.appStorage(key: .userID)) var userID: Int = 0
    @Shared(.appStorage(key: .username)) var username: String = ""
    
    @Dependency(\.authClient) var authClient
    @Dependency(\.appClient) var appClient
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                return .run { send in
                    let deviceID = await appClient.deviceID()
                    let request = SignInRequest(deviceId: deviceID)
                    await send(.signInResponse(Result { try await authClient.signIn(request: request) }))
                }
            case let .signInResponse(.success(jwtToken)):
                self.accessToken = jwtToken
                guard let jwtWithoutBearer = jwtToken.split(separator: " ").last,
                      let jwt = try? JWTDecoder.decode(String(jwtWithoutBearer))
                else { return .send(.signInResponse(.failure(AuthError.jwtDecodeFail)))}
                self.userID = jwt.payload.userId
                self.username = jwt.payload.name
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
