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
                    ForEach(store.grades, id: \.self) {
                        Text($0.title)
                    }
                }
                .pickerStyle(.wheel)
                
                
                Text(store.criteria.description)
                
                Button {
                    store.send(.startButtonTapped)
                } label: {
                    Text("운동 시작하기")
                        .foregroundStyle(.ptWhite)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical , 14)
                        .background(.ptPoint)
                }
                .padding()
                .padding(.horizontal, 20)
                .fullScreenCover(
                    item: $store.scope(state: \.timer, action: \.timer)
                ) { store in
                    TimerView(store: store)
                }
            }
            .navigationTitle("팔굽혀펴기")
        }
        .background(Color.ptBackground)
        
    }
    
}

#Preview {
    WorkoutView(store: .init(initialState: WorkoutFeature.State(), reducer: {
        WorkoutFeature()
    }))
}
