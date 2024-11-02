//
//  OnboardingFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

enum Gender: String, CaseIterable {
    case male
    case female
    
    var title: String {
        switch self {
        case .male: "남자"
        case .female: "여자"
        }
    }
}

@Reducer
struct OnboardingFeature {
    
    enum Step: Int, CaseIterable {
        case yearOfBirth = 1
        case name = 2
        case gender = 3
    }
    
    @ObservableState
    struct State: Equatable {
        var yearOfBirth: Int = 2000
        var name: String = "홍길동"
        var gender: Gender = .male
        var progress: Double = Double(Step.yearOfBirth.rawValue) / Double(Step.allCases.count)
        var currentStep: Step = .yearOfBirth
    }
    
    enum Action {
        case stepChanged(Step)
        case backButtonTapped
        case yearOfBirthChanged(Int)
        case nameChanged(String)
        case genderChanged(Gender)
        case continueButtonTapped
        case signUp
        case signUpResponse(Result<Void, Error>)
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
                let prevStep = Step(rawValue: state.currentStep.rawValue - 1 ) ?? .yearOfBirth
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
                let nextStep = Step(rawValue: state.currentStep.rawValue + 1) ?? .gender
                return .send(.stepChanged(nextStep))
                
            case .signUp:
                return .run { [
                    name = state.name ,
                    yearOfBirth = state.yearOfBirth,
                    gender = state.gender] send in
                    let deviceID = await appClient.deviceID()
                    let request = SignUpRequest(
                        deviceId: deviceID,
                        name: name,
                        age: yearOfBirth,
                        gender: gender.rawValue
                    )
                    await send(.signUpResponse(Result { try await authClient.signUp(request: request) }))
                }
            case .signUpResponse(.success(_)):
                return .none
            case .signUpResponse(.failure(_)):
                return .none
            }
        }
    }
}
