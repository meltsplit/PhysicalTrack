//
//  WorkoutFeatureTests.swift
//  PhysicalTrackUnitTests
//
//  Created by 장석우 on 11/13/24.
//

import ComposableArchitecture
import Testing

@testable import PhysicalTrack

@MainActor
struct WorkoutFeatureTest {
    
    @Test
    func gradeChanged_criteriaIsUpdated() async {
        
        let store = TestStore(initialState: WorkoutFeature.State()) {
            WorkoutFeature()
        }
        
        await store.send(.gradeChanged(.grade1)) {
            $0.grade = .grade1
        }
        
        
        
    }
}
