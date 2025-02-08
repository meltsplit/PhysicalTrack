//
//  UserInfoFeatureTests.swift
//  PhysicalTrackUnitTests
//
//  Created by 장석우 on 2/8/25.
//

import ComposableArchitecture
import Testing
import Foundation

@testable import PhysicalTrack

@MainActor
struct UserInfoFeatureTest {
    
    @Test
    func 회원탈퇴_성공시_로컬스토리지가_초기화된다() async {
        let mockStorage = UserDefaults(suiteName: "test")!
        mockStorage.set("value1", forKey: PTAppStorageKey.accessToken.rawValue)
        
        let store = TestStore(
            initialState: UserInfoFeature.State.init()
        ) {
            UserInfoFeature()
        } withDependencies: {
            $0.defaultAppStorage = mockStorage
        }
        
        await store.send(.withdrawResponse(.success(())))
        await store.skipReceivedActions()
        
        #expect(mockStorage.string(forKey: PTAppStorageKey.accessToken.rawValue) != "value1")
    }
}

