//
//  RootFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

enum RootScene {
    case splash
    case onboarding
    case main
}

@Reducer
struct RootFeature {
    
    @ObservableState
    struct State {
        @Shared(.selectedRootScene) var selectedScene = RootScene.splash
        
        var onboarding: OnboardingFeature.State? = .init()
        var main: MainFeature.State? = .init()
    }
    
    enum Action {
        case onAppear
        case signInResponse(Result<String, Error>)
        
        case onboarding(OnboardingFeature.Action)
        case main(MainFeature.Action)
    }
    
    @Shared(.accessToken) var accessToken: String = ""
    @Shared(.userID) var userID: Int = 0
    @Shared(.username) var username: String = ""
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.authClient.signIn) var signIn
    @Dependency(\.appClient.deviceID) var deviceID
    
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                state.onboarding = OnboardingFeature.State()
                state.main = MainFeature.State()
                return .run { send in
                    let deviceID = await deviceID()
                    let request = SignInRequest(deviceId: deviceID)
                    async let timer: Void = clock.sleep(for: .seconds(2))
                    async let signInResult = Result { try await signIn(request) }
                    let (_, result) = try await (timer, signInResult)
                    await send(.signInResponse(result))
                }
            case let .signInResponse(.success(jwtToken)):
                
                guard let jwtWithoutBearer = jwtToken.components(separatedBy: " ").last,
                      let jwt = try? JWTDecoder.decode(jwtWithoutBearer)
                else { return .send(.signInResponse(.failure(AuthError.jwtDecodeFail)))}
                self.$accessToken.withLock{ $0 = jwtToken }
                self.$userID.withLock{ $0 = jwt.payload.userId }
                self.$username.withLock { $0 = jwt.payload.name }
                state.$selectedScene.withLock { $0 = .main }
                return .none
            case .signInResponse(.failure(_)):
                state.$selectedScene.withLock { $0 = .onboarding }
                return .none
            case .onboarding, .main:
                return .none
            }
        
        }
        .ifLet(\.onboarding, action: \.onboarding) {
            OnboardingFeature()
        }
        .ifLet(\.main, action: \.main) {
            MainFeature()
        }
    }
}
