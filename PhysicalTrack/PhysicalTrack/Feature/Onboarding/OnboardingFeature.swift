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
        
        var name: String = "홍길동"
        var gender: Gender = .male
        var yearOfBirth: Int = 2000
        
        var isLoading: Bool = false
        var currentStep: Step = .name
        var progress: Double = Double(Step.name.rawValue) / Double(Step.allCases.count)
        
        @Shared(.appStorage(key: .accessToken)) var accessToken: String = ""
        @Shared(.appStorage(key: .userID)) var userID: Int = 0
        @Shared(.appStorage(key: .username)) var username: String = "홍길동"
    }
    
    enum Action {
        case stepChanged(Step)
        case backButtonTapped
        case yearOfBirthChanged(Int)
        case nameChanged(String)
        case genderChanged(Gender)
        case continueButtonTapped
        case signUp
        case signUpResponse(Result<String, Error>)
    }
    
    @Dependency(\.appClient) var appClient
    @Dependency(\.authClient) var authClient
    
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
                
            case .continueButtonTapped:
                guard state.currentStep.rawValue < Step.allCases.count
                else { return .send(.signUp)}
                let nextStep = Step(rawValue: state.currentStep.rawValue + 1) ?? .yearOfBirth
                return .send(.stepChanged(nextStep))
                
            case .signUp:
                state.isLoading = true
                return .run { [state] send in
                    let deviceID = await appClient.deviceID()
                    let request = SignUpRequest(
                        deviceId: deviceID,
                        name: state.name,
                        birthYear: state.yearOfBirth,
                        gender: state.gender.toData()
                    )
                    let response = await Result { try await authClient.signUp(request: request) }
                    await send(.signUpResponse(response))
                }
            case let .signUpResponse(.success(jwtToken)):
                state.accessToken = jwtToken
                guard let jwtWithoutBearer = jwtToken.split(separator: " ").last,
                      let jwt = try? JWTDecoder.decode(String(jwtWithoutBearer))
                else { return .send(.signUpResponse(.failure(AuthError.jwtDecodeFail)))}
                state.userID = jwt.payload.userId
                state.username = jwt.payload.name
                return .none
            case .signUpResponse(.failure(_)):
                state.isLoading = false
                return .none
            }
        }
    }
}
