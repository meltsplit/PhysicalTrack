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
struct TimerFeatureTests {

    @Test
    func test_타이머가_10초후에_종료된다() async {
        let store = TestStore(initialState: TimerFeature.State(
            PushUpRecord(duration: .seconds(10), targetCount: 10)
        )) {
            TimerFeature()
        } withDependencies: {
            $0.proximityClient = .testValue
            $0.continuousClock = ImmediateClock()
        }
        
        await store.send(.onAppear)
        await store.receive(\.start)
        await store.receive(\.timerTick) { $0._leftSeconds = 9 }
        await store.receive(\.timerTick) { $0._leftSeconds = 8 }
        await store.receive(\.timerTick) { $0._leftSeconds = 7 }
        await store.receive(\.timerTick) { $0._leftSeconds = 6 }
        await store.receive(\.timerTick) { $0._leftSeconds = 5 }
        await store.receive(\.timerTick) { $0._leftSeconds = 4 }
        await store.receive(\.timerTick) { $0._leftSeconds = 3 }
        await store.receive(\.timerTick) { $0._leftSeconds = 2 }
        await store.receive(\.timerTick) { $0._leftSeconds = 1 }
        await store.receive(\.timerTick) { $0._leftSeconds = 0 }
        await store.receive(\.timerTick)
        await store.receive(\.finish) {
            $0.presentResult = true
        }
                            
    }
    
    @Test
    func test_timer_proximity() async {
        let clock = TestClock()
        let store = TestStore(initialState: TimerFeature.State(
            PushUpRecord(duration: .seconds(10), targetCount: 10)
        )) {
            TimerFeature()
        } withDependencies: {
            $0.proximityClient = .init(start: {
                return AsyncStream<Bool> { continuation in
                    Task {
                        for try await _ in clock.timer(interval: .seconds(2)) {
                            continuation.yield(true)
                        }
                    }
                }
            }, stop: { return })
            $0.continuousClock = clock
        }
        
        await store.send(.onAppear)
        await store.receive(\.start)
        await clock.advance(by: .seconds(11))
        await store.receive(\.timerTick) { $0._leftSeconds = 9 }
        await store.receive(\.detected) { $0.record.count = 1 }
        
        await store.receive(\.timerTick) { $0._leftSeconds = 8 }
        await store.receive(\.timerTick) { $0._leftSeconds = 7 }
        await store.receive(\.detected) { $0.record.count = 2 }
        
        await store.receive(\.timerTick) { $0._leftSeconds = 6 }
        await store.receive(\.timerTick) { $0._leftSeconds = 5 }
        await store.receive(\.detected) { $0.record.count = 3 }
        
        await store.receive(\.timerTick) { $0._leftSeconds = 4 }
        await store.receive(\.timerTick) { $0._leftSeconds = 3 }
        await store.receive(\.detected) { $0.record.count = 4 }
        
        await store.receive(\.timerTick) { $0._leftSeconds = 2 }
        await store.receive(\.timerTick) { $0._leftSeconds = 1 }
        await store.receive(\.detected) { $0.record.count = 5 }
        
        await store.receive(\.timerTick) { $0._leftSeconds = 0 }
        await store.receive(\.timerTick)
        await store.receive(\.finish) {
            $0.presentResult = true
        }
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
        
        await store.send(.onAppear)
        await store.receive(\.start)
        await clock.advance(by: .seconds(4))
        await store.receive(\.timerTick) { $0._leftSeconds = 9 }
        await store.receive(\.timerTick) { $0._leftSeconds = 8 }
        await store.receive(\.timerTick) { $0._leftSeconds = 7 }
        await store.receive(\.timerTick) { $0._leftSeconds = 6 }
        await store.send(.quitButtonTapped) {
            $0.alert = AlertState(
                title: { TextState("운동을 종료하시겠습니까?") },
                actions: {
                    ButtonState(action: .quit, label: { TextState("종료") })
                    ButtonState(action: .resume, label: { TextState("재개") })
                },
                message: { TextState("수행한 운동은 저장되지 않습니다") }
            )
        }
        await store.receive(\.pause)
        
        await store.send(.alert(.presented(.resume))) {
            $0.alert = nil
        }
        await store.receive(\.start)
        await clock.advance(by: .seconds(7))
        await store.receive(\.timerTick) { $0._leftSeconds = 5 }
        await store.receive(\.timerTick) { $0._leftSeconds = 4 }
        await store.receive(\.timerTick) { $0._leftSeconds = 3 }
        await store.receive(\.timerTick) { $0._leftSeconds = 2 }
        await store.receive(\.timerTick) { $0._leftSeconds = 1 }
        await store.receive(\.timerTick) { $0._leftSeconds = 0 }
        await store.receive(\.timerTick)
        await store.receive(\.finish) {
            $0.presentResult = true
        }
       
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
        
        await store.send(.onAppear)
        await store.receive(\.start)
        await clock.advance(by: .seconds(3))
        await store.send(.quitButtonTapped)
        await store.receive(\.pause)
        
        // 무효화 되어야 할 운동 ---
        proximityStream.continuation.yield(true) //영
        proximityStream.continuation.yield(false) //차
        proximityStream.continuation.yield(true) //영
        proximityStream.continuation.yield(false) //차
        // ---
        
        await store.send(.alert(.presented(.resume)))
        await store.receive(\.start)
        await clock.advance(by: .seconds(8))
        await store.receive(\.finish) {
            $0.presentResult = true
        }
       
    }


}
