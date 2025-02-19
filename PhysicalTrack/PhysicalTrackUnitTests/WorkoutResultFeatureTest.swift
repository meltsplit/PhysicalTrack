//
//  WorkoutResultFeatureTest.swift
//  PhysicalTrackUnitTests
//
//  Created by 장석우 on 2/18/25.
//

import Testing
@testable import PhysicalTrack
import ComposableArchitecture

@MainActor
struct WorkoutResultFeatureTest {
    
    @Suite("RunningResult")
    @MainActor
    struct RunningResult { }
    
    @Suite("PushUpResult")
    @MainActor
    struct PushUpResult { }
}


extension WorkoutResultFeatureTest.PushUpResult {
    
    @Test
    func 푸시업결과뷰_진입시_푸시업기록을_서버로_전송한다() async {
        
        let isCalled = LockIsolated(false)
        
        let store = TestStore(initialState: PushUpResultFeature.State(record: PushUpRecord(for: .elite))) {
            PushUpResultFeature()
        } withDependencies: {
            $0.workoutClient.savePushUpRecord = { _ in isCalled.setValue(true) }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        #expect(isCalled.value)
    }
}

extension WorkoutResultFeatureTest.RunningResult {
    
    @Test
    func 러닝결과뷰_진입시_러닝기록을_서버로_전송한다() async {
        
        let isCalled = LockIsolated(false)
        
        let store = TestStore(initialState: RunningResultFeature.State(record: RunningRecord(for: .elite))) {
            RunningResultFeature()
        } withDependencies: {
            $0.workoutClient.saveRunningRecord = { _ in isCalled.setValue(true) }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        #expect(isCalled.value)
    }
}
