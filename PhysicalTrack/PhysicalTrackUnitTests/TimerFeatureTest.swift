//
//  TimerFeatureTests.swift
//  PhysicalTrackUnitTests
//
//  Created by 장석우 on 11/13/24.
//

import Testing
import ComposableArchitecture

@testable import PhysicalTrack
@MainActor
struct TimerFeatureTest {
    
    @Test
    func test_timer가_2분으로_설정되었는가() async {
        assert(PushUpRecord(for: .elite).duration == .seconds(120))
    }
    
    @Test
    func test_when_onAppear_then_ready_3초후_시작() async {
        let clock = ImmediateClock()
        
        let store = TestStore(initialState: TimerFeature.State(
            .init(duration: .seconds(120), targetCount: 72)
        )) {
            TimerFeature()
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
    func test_종료버튼을누르면_타이머가_중단된다() async {
        let clock = TestClock()
        let store = TestStore(initialState: TimerFeature.State(
            PushUpRecord(duration: .seconds(10), targetCount: 10)
        )) {
            TimerFeature()
        } withDependencies: {
            $0.proximityClient = .testValue
            $0.continuousClock = clock
        }
        
        store.exhaustivity = .off
        
        await store.send(.start)
        await store.send(.quitButtonTapped)
        await store.receive(\.pause)
        
        await clock.advance(by: .seconds(7))
        
        await store.finish()
        
    }
    
    
    @Test
    func test_종료버튼을_누르면_ProximityClient를_cancel한다() async {
        let clock = TestClock()
        let proximityStream = AsyncStream.makeStream(of: Bool.self)
        let stubProximityStream = ProximityClient(
            start: {@Sendable in proximityStream.stream },
            stop: { @Sendable in proximityStream.continuation.finish() }
        )
        let store = TestStore(initialState: TimerFeature.State(
            PushUpRecord(duration: .seconds(10), targetCount: 10))
        ) {
            TimerFeature()
        } withDependencies: {
            $0.proximityClient = stubProximityStream
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
        proximityStream.continuation.yield(true) //영
        proximityStream.continuation.yield(false) //차
        // ---
        let after = store.state.record.count
        
        #expect(before == after)
        await store.finish()
    }
}
