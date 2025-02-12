//
//  RunningFeatureTest.swift
//  PhysicalTrackUnitTests
//
//  Created by 장석우 on 2/11/25.
//

import Testing

@testable import PhysicalTrack
import ComposableArchitecture
import CoreLocation



@MainActor
struct RunningFeatureTest {

    @Suite("Running")
    @MainActor
    struct Running { }
}

extension RunningFeatureTest.Running {
    
    @Test
    func 첫_업데이트에선_totalDistance가_갱신되지_않는다() async {
        let location1: Location = .stub(
            speed: 4.0,
            timestamp: .init(timeIntervalSince1970: 1),
            distance: { _ in 5 }
        )
        
        let store = TestStore(
            initialState: RunningFeature.State()
        ) {
            RunningFeature()
        }
        
        await store.send(.locationUpdated(location1)) {
            $0.locations = [location1]
            $0.totalDistance = 0
        }
        await store.finish()
    }
    
    @Test
    func 위치가_업데이트되면_totalDistance에_거리가_반영된다() async {
        let location1: Location = .stub(
            speed: 0,
            timestamp: .init(),
            distance: { _ in 0 }
        )
        
        let location2: Location = .stub(
            speed: 0,
            timestamp: .init(),
            distance: { _ in 777 }
        )
        
        let store = TestStore(
            initialState: RunningFeature.State()
        ) {
            RunningFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.locationUpdated(location1))
        
        await store.send(.locationUpdated(location2)) {
            $0.locations = [location1, location2]
            $0.totalDistance = 777
        }
        
        await store.finish()
    }
    
    @Test
    func 위치가_업데이트되면_timeIntervals에_시간이_추가된다() async {
        let location1: Location = .stub(
            speed: 0,
            timestamp: .init(timeIntervalSince1970: 0),
            distance: { _ in 0 }
        )
        
        let location2: Location = .stub(
            speed: 0,
            timestamp: .init(timeIntervalSince1970: 10),
            distance: { _ in 4 }
        )
        
        let store = TestStore(
            initialState: RunningFeature.State()
        ) {
            RunningFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.locationUpdated(location1))
        
        await store.send(.locationUpdated(location2)) {
            var index = 4 / RunningFeature.Policy.unitDistance
            index = min(index, store.state.timeIntervals.count - 1)
            $0.timeIntervals[index] = 10
        }
        
        await store.finish()
    }
    
    @Test
    func 총거리가_3km이상이면_종료된다() async {
        let location1: Location = .stub(
            speed: 0,
            timestamp: .init(timeIntervalSince1970: 0),
            distance: { _ in 0 }
        )
        
        let location2: Location = .stub(
            speed: 0,
            timestamp: .init(timeIntervalSince1970: 1000),
            distance: { _ in 2999 }
        )
        
        let location3: Location = .stub(
            speed: 0,
            timestamp: .init(timeIntervalSince1970: 1001),
            distance: { _ in 2 }
        )
        
        let store = TestStore(
            initialState: RunningFeature.State()
        ) {
            RunningFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.locationUpdated(location1))
        await store.send(.locationUpdated(location2))
        await store.send(.locationUpdated(location3))
        await store.receive(\.finish)
        await store.finish()
        
    }
}
