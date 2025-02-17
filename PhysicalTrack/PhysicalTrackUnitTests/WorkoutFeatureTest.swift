//
//  WorkoutFeatureTests.swift
//  PhysicalTrackUnitTests
//
//  Created by 장석우 on 11/13/24.
//


import Testing
@testable import PhysicalTrack
import ComposableArchitecture

@MainActor
struct WorkoutFeatureTest {
    
    @Suite("LocationAuthorization")
    @MainActor
    struct LocationAuthorization { }
}

extension WorkoutFeatureTest {
    
    @Test
    func 홈화면_진입시_첫번째_단계는_운동선택이다() async throws {
        let store = TestStore(
            initialState: WorkoutFeature.State()
        ) {
            WorkoutFeature()
        }
        
        #expect(store.state.phase == WorkoutFeature.State.Phase.selectWorkout)
    }
    
    @Test
    func 운동선택_단계에서_완료버튼을_누르면_등급선택_단계로_변경된다() async throws {
        let store = TestStore(
            initialState: WorkoutFeature.State()
        ) {
            WorkoutFeature()
        }
        
        store.exhaustivity = .off
        await store.send(.doneButtonTapped) {
            $0.phase = .selectGrade
        }
    }
    
    @Test
    func 등급선택_단계에서_리셋버튼을_누르면_운동선택_단계로_변경된다() async throws {
        let store = TestStore(
            initialState: WorkoutFeature.State()
        ) {
            WorkoutFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.doneButtonTapped) {
            $0.phase = .selectGrade
        }
        
        await store.send(.resetButtonTapped) {
            $0.phase = .selectWorkout
        }
    }


}

extension WorkoutFeatureTest.LocationAuthorization {
    
    @Test
    func 위치접근권한이_notDetermined_일때_권한을_요청한다() async {
        
        let isCalled = LockIsolated(false)
        
        let store = TestStore(initialState: WorkoutFeature.State()) {
            WorkoutFeature()
        } withDependencies: {
            $0.locationClient.authorizationStatus = { .notDetermined }
            $0.locationClient.requestAuthorization = { isCalled.setValue(true) }
        }
        
        store.exhaustivity = .off
        
        await store.send(.startRunning)
        
        #expect(isCalled.value)
    }
    
    @Test
    func 위치접근권한이_허용일때_됐을때_시작한다() async {
        
        let store = TestStore(
            initialState: WorkoutFeature.State()
        ) {
            WorkoutFeature()
        } withDependencies: {
            $0.locationClient.authorizationStatus = { .authorized }
            $0.locationClient.requestAuthorization = { }
        }
        
        await store.send(.startRunning) {
            $0.running = RunningFeature.State(record: RunningRecord(for: .elite))
        }
        
        await store.finish()
    }
    
    @Test
    func 위치접근권한이_거부일때_설정화면_이동_알럿을_띄운다() async {
        
        let store = TestStore(initialState: WorkoutFeature.State()) {
            WorkoutFeature()
        } withDependencies: {
            $0.locationClient.authorizationStatus = { .unauthorized }
            $0.locationClient.requestAuthorization = { }
        }
        
        store.exhaustivity = .off
        
        await store.send(.startRunning)
        await store.finish()
        
        #expect(store.state.alert != nil)
    }
}

