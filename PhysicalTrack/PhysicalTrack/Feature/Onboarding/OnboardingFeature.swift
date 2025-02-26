//
//  OnboardingFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct OnboardingFeature {
    
    enum Step: Int, CaseIterable {
        case name = 1
        case gender = 2
        case yearOfBirth = 3
    }
    
    @ObservableState
    struct State: Equatable {
        @Shared(.selectedRootScene) var selectedRootScene = RootScene.onboarding
        
        var name: String = "홍길동"
        var gender: Gender = .male
        var yearOfBirth: Int = 2000
        
        var isLoading: Bool = false
        var currentStep: Step = .name
        var progress: Double = Double(Step.name.rawValue) / Double(Step.allCases.count)
        
        @Shared(.accessToken) var accessToken = ""
        @Shared(.userID) var userID = 0
        @Shared(.username) var username = "홍길동"
    }
    
    enum Action {
        case stepChanged(Step)
        case backButtonTapped
        case yearOfBirthChanged(Int)
        case nameChanged(String)
        case genderChanged(Gender)
        case doneButtonTapped
        case signUp
        case signUpResponse(Result<String, Error>)
    }
    
    @Dependency(\.appClient.deviceID) var deviceID
    @Dependency(\.authClient.signUp) var signUp
    @Dependency(\.jwtDecoder.decode) var decode
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case let .stepChanged(step):
                state.currentStep = step
                state.progress = Double(step.rawValue) / Double(Step.allCases.count)
                return .none
            case .backButtonTapped:
                let prevStep = Step(rawValue: state.currentStep.rawValue - 1 ) ?? .name
                return .send(.stepChanged(prevStep))
          
            case let .yearOfBirthChanged(year):
                state.yearOfBirth = year
                return .none

            case let .nameChanged(name):
                state.name = name
                return .none
                
            case let .genderChanged(gender):
                state.gender = gender
                return .none
                
            case .doneButtonTapped:
                guard state.currentStep.rawValue < Step.allCases.count
                else { return .send(.signUp)}
                let nextStep = Step(rawValue: state.currentStep.rawValue + 1) ?? .yearOfBirth
                return .send(.stepChanged(nextStep))
                
            case .signUp:
                state.isLoading = true
                return .run { [state] send in
                    let deviceID = await deviceID()
                    let request = SignUpRequest(
                        deviceId: deviceID,
                        name: state.name,
                        birthYear: state.yearOfBirth,
                        gender: state.gender.toData()
                    )
                    let response = await Result { try await signUp(request) }
                    await send(.signUpResponse(response))
                }
            case let .signUpResponse(.success(jwtToken)):
                guard let jwt = try? decode(jwtToken)
                else { return .send(.signUpResponse(.failure(AuthError.jwtDecodeFail)))}
                state.$accessToken.withLock{ $0 = jwtToken }
                state.$userID.withLock{ $0 = jwt.payload.userId }
                state.$username.withLock { $0 = jwt.payload.name }
                state.$selectedRootScene.withLock { $0 = .main }
                return .none
            case .signUpResponse(.failure(_)):
                state.isLoading = false
                return .none
            }
        }
    }
}
