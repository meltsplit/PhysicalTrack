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
                
                Spacer()
                
                HStack() {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("\(store.username)님")
                            .font(.title3.bold())
                            .foregroundStyle(.gray)
                        Text("지금 운동하시나요?")
                            .font(.title.bold())
                        
                        Text("목표 등급을 선택하세요.")
                            .font(.title.bold())
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Picker("grade",
                       selection: $store.grade.sending(\.gradeChanged))
                {
                    ForEach(store.grades, id: \.self) {
                        Text($0.title)
                            .font(.title)
                    }
                }
                .pickerStyle(.wheel)
                
                Spacer()
                
                PTColorText(
                    "2분 동안 \(store.criteria.value.lowerBound)회 이상 수행해야 해요.",
                    at: "\(store.criteria.value.lowerBound)회",
                    color: .ptWhite,
                    weight: .bold
                )
                .foregroundStyle(.ptGray)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
                
                
                PTButton{
                    store.send(.startRunningButtonTapped)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("운동 시작하기")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                
                Spacer()
                    .frame(height: 20)
            }
            .background(Color.ptBackground)
            .sheet(
                item: $store.scope(state: \.tutorial, action: \.tutorial)
            ) { store in
                TutorialView(store: store)
                    .presentationDetents([.medium])
            }
            .fullScreenCover(
                item: $store.scope(state: \.timer, action: \.timer)
            ) { store in
                PushUpView(store: store)
            }
            .fullScreenCover(
                item: $store.scope(state: \.running, action: \.running)
            ) { store in
                RunningView(store: store)
            }
            .alert($store.scope(state: \.alert, action: \.alert))
        }
        
        
    }
    
}

#Preview {
    WorkoutView(store: .init(initialState: WorkoutFeature.State(), reducer: {
        WorkoutFeature()
    }))
}
