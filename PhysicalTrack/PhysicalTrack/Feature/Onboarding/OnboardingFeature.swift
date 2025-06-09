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
        
        var isFirstStep: Bool {
            self == .name
        }
        
        var isLastStep: Bool {
            self == .yearOfBirth
        }
        
        var progressRatio: Double {
            Double(self.rawValue) / Double(Step.allCases.count)
        }
        
        var prevStep: Step {
            Step(rawValue: self.rawValue - 1 ) ?? .name
        }
        
        var nextStep: Step {
            Step(rawValue: self.rawValue + 1 ) ?? .yearOfBirth
        }
    }
    
    @ObservableState
    struct State: Equatable {
        @Shared(.selectedRootScene) var selectedRootScene = RootScene.onboarding

        var name = NameFeature.State()
        var gender = GenderFeature.State()
        var birth = BirthFeature.State()
        
        var doneButtonDisabled = true
        
        var isLoading: Bool = false
        var currentStep: Step = .name
        
        @Shared(.accessToken) var accessToken = ""
        @Shared(.userID) var userID = 0
        @Shared(.username) var username = "홍길동"
    }
    
    enum Action {
        case name(NameFeature.Action)
        case gender(GenderFeature.Action)
        case birth(BirthFeature.Action)
        case stepChanged(Step)
        case backButtonTapped
        case doneButtonTapped
        case signUp
        case signUpResponse(Result<String, Error>)
    }
    
    @Dependency(\.appClient.deviceID) var deviceID
    @Dependency(\.authClient.signUp) var signUp
    @Dependency(\.jwtDecoder.decode) var decode
    
    var body: some ReducerOf<Self> {
        Scope(state: \.name, action: \.name) {
            NameFeature()
        }
        Scope(state: \.gender, action: \.gender) {
            GenderFeature()
        }
        Scope(state: \.birth, action: \.birth) {
            BirthFeature()
        }
        Reduce { state , action in
            switch action {
            case let .stepChanged(step):
                state.currentStep = step
                return .none
            case .backButtonTapped:
                let prevStep = state.currentStep.prevStep
                return .send(.stepChanged(prevStep))
          
            case .doneButtonTapped:
                if state.currentStep.isLastStep {
                    return .send(.signUp)
                } else {
                    let nextStep = state.currentStep.nextStep
                    return .send(.stepChanged(nextStep))
                }
            case .signUp:
                state.isLoading = true
                return .run { [state] send in
                    let deviceID = await deviceID()
                    let request = SignUpRequest(
                        deviceId: deviceID,
                        name: state.name.name,
                        birthYear: state.birth.yearOfBirth,
                        gender: state.gender.gender.toData()
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
            case .name(.validate(let isValid)):
                state.doneButtonDisabled = !isValid
                return .none
            case .name(_):
                return .none
            case .gender:
                return .none
            case .birth:
                return .none
            }
        }

    }
}


@Reducer
struct NameFeature {
    
    @ObservableState
    struct State: Equatable {
        var name: String = "홍길동"
    }
    
    enum Action {
        case nameChanged(String)
        case validate(Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nameChanged(let name):
                state.name = name
                return .send(.validate(!name.isEmpty))
            case .validate:
                return .none
            }
        }
    }
}

@Reducer
struct GenderFeature {
    
    @ObservableState
    struct State: Equatable {
        var gender: Gender = .male
    }
    
    enum Action {
        case genderChanged(Gender)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .genderChanged(let gender):
                state.gender = gender
                return .none
            }
        }
    }
}

@Reducer
struct BirthFeature {
    
    @ObservableState
    struct State: Equatable {
        var yearOfBirth: Int = 2000
    }
    
    enum Action {
        case yearOfBirthChanged(Int)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .yearOfBirthChanged(year):
                state.yearOfBirth = year
                return .none
            }
        }
    }
}
