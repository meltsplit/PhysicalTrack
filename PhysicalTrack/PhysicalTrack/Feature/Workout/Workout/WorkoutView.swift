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
        NavigationStack {
            VStack {
                Picker("grade",
                       selection: $store.grade.sending(\.gradeButtonTapped))
                {
                    ForEach(Grade.allCases, id: \.self) {
                        Text($0.title)
                    }
                }
                .pickerStyle(.menu)
                
                
                Text(store.criteria.description)
                
                Button("스타트")
                {
                    store.send(.startButtonTapped)
                }
                .padding()
                .fullScreenCover(
                    item: $store.scope(state: \.timer, action: \.timer)
                ) { store in
                    TimerView(store: store)
                }
            }
            .navigationTitle("팔굽혀펴기")
        }
        
    }
    
}

#Preview {
    WorkoutView(store: .init(initialState: WorkoutFeature.State(), reducer: {
        WorkoutFeature()
    }))
}
