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
                        Text("회원님")
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
                
                Button {
                    store.send(.startButtonTapped)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("운동 시작하기")
                    }
                }
                .ptBottomButtonStyle()
                .padding(.horizontal, 20)
                .fullScreenCover(
                    item: $store.scope(state: \.timer, action: \.timer)
                ) { store in
                    TimerView(store: store)
                }
                
                Spacer()
                    .frame(height: 20)
            }
        }
        .background(Color.ptBackground)
        
    }
    
}

#Preview {
    WorkoutView(store: .init(initialState: WorkoutFeature.State(), reducer: {
        WorkoutFeature()
    }))
}
