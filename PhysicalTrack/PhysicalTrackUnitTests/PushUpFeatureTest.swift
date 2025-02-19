//
//  PushUpFeatureTests.swift
//  PhysicalTrackUnitTests
//
//  Created by 장석우 on 11/13/24.
//

import Testing

@testable import PhysicalTrack
import ComposableArchitecture

@MainActor
struct PushUpFeatureTest {
    
    @Test
    func 푸시업기록_엔티티의_기간은_120초이다() async {
        #expect(PushUpRecord(for: .elite).duration == .seconds(120))
    }
    
    @Test
    func 푸시업뷰_진입시_준비타이머_3초후_운동이_시작된다() async {
        let clock = ImmediateClock()
        let store = TestStore(
            initialState: PushUpFeature.State(
                PushUpRecord.stub()
            )) {
                PushUpFeature()
            } withDependencies: {
                $0.continuousClock = clock
            }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.ready)
        await store.receive(\.readyTimerTick) { $0.readyLeftSeconds = 2 }
        await store.receive(\.readyTimerTick) { $0.readyLeftSeconds = 1 }
        await store.receive(\.readyTimerTick) { $0.readyLeftSeconds = 0 }
        await store.receive(\.readyTimerTick)
        await store.receive(\.start)
        await store.finish()
        
    }
    
    @Test
    func 정지버튼을_누르면_실제시간이_흘러도_운동시간은_증가하지_않는다() async {
        let clock = TestClock()
        let store = TestStore(initialState: PushUpFeature.State(
            PushUpRecord.stub()
        )) {
            PushUpFeature()
        } withDependencies: {
            $0.proximityClient = .testValue
            $0.continuousClock = clock
        }
        
        store.exhaustivity = .off
        
        await store.send(.start)
        await store.send(.quitButtonTapped)
        await store.receive(\.pause)
        
        let before = store.state.workoutLeftSeconds
        await clock.advance(by: .seconds(7))
        let after = store.state.workoutLeftSeconds
        
        #expect(before == after)
    }
    
    @Test
    func 정지버튼을_누르면_근접센서에_값이_들어와도_운동횟수는_증가하지_않는다() async {
        let clock = TestClock()
        let (stream, continuation) = AsyncStream.makeStream(of: Bool.self)
        
        let store = TestStore(
            initialState:
                PushUpFeature.State(.stub())
        ) {
            PushUpFeature()
        } withDependencies: {
            $0.proximityClient.start = { @Sendable in stream }
            $0.proximityClient.stop = { @Sendable in continuation.finish() }
            $0.continuousClock = clock
        }
        
        store.exhaustivity = .off
        
        await store.send(.start) {
            $0.record.count = 0
        }
        
        await store.send(.quitButtonTapped)
        await store.receive(\.pause)
        
        let before = store.state.record.count
        // 무효화 되어야 할 운동 ---
        continuation.yield(true) //영
        continuation.yield(false) //차
        // ---
        let after = store.state.record.count
        
        #expect(before == after)
    }
}
