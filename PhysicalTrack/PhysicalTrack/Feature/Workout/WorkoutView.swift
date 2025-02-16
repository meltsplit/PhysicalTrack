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
                
                Text("\(store.username)님")
                    .font(.title3.bold())
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                
                TitleView(
                    step: store.step,
                    selectedExercise: store.selectedExercise
                ) {
                    store.send(.resetButtonTapped)
                }
                .padding(.horizontal, 20)
                
                switch store.step {
                case .workout:
                    Picker("workout",
                           selection: $store.selectedExercise.sending(\.exerciseChanged))
                    {
                        ForEach(Exercise.allCases, id: \.self) {
                            Text($0.title)
                                .font(.title)
                        }
                    }
                    .pickerStyle(.wheel)
                case .grade:
                    Picker("grade",
                           selection: $store.grade.sending(\.gradeChanged))
                    {
                        ForEach(store.grades, id: \.self) {
                            Text($0.title)
                                .font(.title)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                Spacer()
                
                //                PTColorText(
                //                    "2분 동안 \(store.criteria.value.lowerBound)회 이상 수행해야 해요.",
                //                    at: "\(store.criteria.value.lowerBound)회",
                //                    color: .ptWhite,
                //                    weight: .bold
                //                )
                //                .foregroundStyle(.ptGray)
                //                .fontWeight(.semibold)
                //                .padding(.bottom, 8)
                
                
                PTButton{
                    store.send(.startButtonTapped)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .opacity(store.step == .workout ? 0 : 1)
                        
                        Text(store.step == .workout ? "완료" : "\(store.selectedExercise.title) 시작하기")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                
                Spacer()
                    .frame(height: 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color.ptBackground)
            .sheet(
                item: $store.scope(state: \.tutorial, action: \.tutorial)
            ) { store in
                TutorialView(store: store)
                    .presentationDetents([.medium])
            }
            .fullScreenCover(
                item: $store.scope(state: \.pushUp, action: \.pushUp)
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

fileprivate struct TitleView: View {
    
    private let step: WorkoutFeature.State.SelectStep
    private let exercise: Exercise
    private var reset: (() -> Void)
    
    var title: String {
        switch step {
        case .workout:
            "지금 운동하시나요?"
        case .grade:
            "\(exercise.title)"
        }
    }
    
    var description: String {
        switch step {
        case .workout:
            "운동을 선택하세요."
        case .grade:
            "목표 등급을 선택하세요."
        }
    }
    
    init(
        step: WorkoutFeature.State.SelectStep,
        selectedExercise: Exercise,
        reset: @escaping (() -> Void)
    ) {
        self.step = step
        self.exercise = selectedExercise
        self.reset = reset
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 14) {
            
            HStack(spacing: 20) {
                Text(title)
                    .font(.title.bold())
                    .animation(.easeInOut(duration:0.7))
                    .contentTransition(.opacity)
                
                Spacer()
                
                if step == .grade {
                    Button {
                        reset()
                    } label: {
                        Text("다시 선택")
                            .font(.headline)
                            .foregroundStyle(.ptPoint)
                    }
                }
                
                
            }
            
            Text(description)
                .font(.title.bold())
                .animation(.easeInOut(duration:0.7))
                .contentTransition(.opacity)
            
            
        }
    }
    
    
}

#Preview {
    WorkoutView(store: .init(initialState: WorkoutFeature.State(), reducer: {
        WorkoutFeature()
    }))
}
