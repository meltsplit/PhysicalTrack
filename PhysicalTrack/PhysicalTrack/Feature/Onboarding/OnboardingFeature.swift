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

        var name: NameFeature.State? = .init()
        var gender: GenderFeature.State? = .init()
        var birth: BirthFeature.State? = .init()
        
        var doneButtonDisabled = true
        var doneButtonTitle = "계속하기"
        
        var isLoading: Bool = false
        var currentStep: Step = .name
        var progress: Double = Double(Step.name.rawValue) / Double(Step.allCases.count)
        
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
        Reduce { state , action in
            switch action {
            case let .stepChanged(step):
                state.currentStep = step
                state.progress = Double(step.rawValue) / Double(Step.allCases.count)
                if step.rawValue == Step.allCases.count {
                    state.doneButtonTitle = "회원가입"
                }
                return .none
            case .backButtonTapped:
                let prevStep = Step(rawValue: state.currentStep.rawValue - 1 ) ?? .name
                return .send(.stepChanged(prevStep))
          
            case .doneButtonTapped:
                guard state.currentStep.rawValue < Step.allCases.count
                else { return .send(.signUp)}
                let nextStep = Step(rawValue: state.currentStep.rawValue + 1) ?? .yearOfBirth
                return .send(.stepChanged(nextStep))
                
            case .signUp:
                state.isLoading = true
                return .run { [state] send in
                    guard let name = state.name?.name,
                          let gender = state.gender?.gender,
                          let birthYear = state.birth?.yearOfBirth
                    else { return }
                    
                    let deviceID = await deviceID()
                    let request = SignUpRequest(
                        deviceId: deviceID,
                        name: name,
                        birthYear: birthYear,
                        gender: gender.toData()
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
        .ifLet(\.name, action: \.name) {
            NameFeature()
        }
        .ifLet(\.gender, action: \.gender) {
            GenderFeature()
        }
        .ifLet(\.birth, action: \.birth) {
            BirthFeature()
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
