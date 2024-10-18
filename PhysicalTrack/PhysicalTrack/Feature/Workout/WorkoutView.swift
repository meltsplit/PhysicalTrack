//
//  ContentView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct WorkoutView: View {
    
    @Bindable var store: StoreOf<WorkoutFeature>
    
    
    var body: some View {
        
        
        Button("스타트")
        {
            store.send(.startButtonTapped)
        }
        .padding()
        .fullScreenCover(
            item: $store.scope(state: \.timer, action: \.timer)
        ) { store in
            TimerView(
                store: .init(initialState: TimerFeature.State()) {
                    TimerFeature()
                }
            )
        }

    }
    
}

#Preview {
    WorkoutView(store: .init(initialState: WorkoutFeature.State(), reducer: {
        WorkoutFeature()
    }))
}
