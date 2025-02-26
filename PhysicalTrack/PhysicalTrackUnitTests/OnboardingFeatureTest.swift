//
//  OnboardingFeatureTest.swift
//  PhysicalTrackUnitTests
//
//  Created by 장석우 on 2/26/25.
//

import Testing
@testable import PhysicalTrack
import ComposableArchitecture

@MainActor
struct OnboardingFeatureTest { }

extension OnboardingFeatureTest {
    
    @Test
    func 온보딩_진입시_첫_단계는_이름선택이다() async {
        let store = TestStore(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
        
        store.exhaustivity = .off
        
        store.assert {
            $0.currentStep = .name
        }
    }
    
    @Test
    func 이름_기입후_완료_버튼을_누르면_성별선택단계로_전환된다() async {
        let store = TestStore(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.nameChanged("장석우"))
        await store.send(.doneButtonTapped)
        await store.receive(\.stepChanged){
            $0.currentStep = .gender
        }
    }
    
    @Test
    func 성별단계에서_완료_버튼을_누르면_나이선택단계로_전환된다() async {
        let store = TestStore(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.stepChanged(.gender))
        await store.send(.doneButtonTapped)
        await store.receive(\.stepChanged){
            $0.currentStep = .yearOfBirth
        }
    }
    
    @Test
    func 회원가입_통신_시작시_로딩중으로_처리된다() async {
        let store = TestStore(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.signUp) {
            $0.isLoading = true
        }
    }
    
    @Test
    func 회원가입_통신중에_로딩중으로_처리된다() async {
        let clock = TestClock()
        
        let store = TestStore(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        } withDependencies: {
            $0.authClient.signUp = { @Sendable _ in
                try await clock.sleep(for: .seconds(3))
                return ""
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.signUp)
        await clock.advance(by: .seconds(1))
        
        store.assert {
            $0.isLoading = true
        }
    }
    
    @Test
    func 회원가입_통신이_끝나면_로딩중_상태가_해제된다() async {
        let store = TestStore(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        } withDependencies: {
            $0.authClient.signUp = { @Sendable _ in
                throw AuthError.unknown
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.signUp)
        await store.receive(\.signUpResponse) {
            $0.isLoading = false
        }
    }
    
    // Shared Test는 breaking Change 예정 https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/sharingstate#Testing-shared-state

//    @Test
//    func 회원가입_응답이_성공일때_메인으로_화면전환한다() async {
//        let store = TestStore(
//            initialState: OnboardingFeature.State()
//        ) {
//            OnboardingFeature()
//        } withDependencies: {
//            $0.authClient.signUp = { @Sendable _ in
//                return ""
//            }
//        }
//        
//        store.exhaustivity = .off
//
//        await store.send(.signUpResponse(.success(""))) {
//            $0.$selectedRootScene.withLock { $0 = .main }
//        }
//        store.assert {
//            $0.$selectedRootScene.withLock { $0 = .main }
//        }
        
    }
}
