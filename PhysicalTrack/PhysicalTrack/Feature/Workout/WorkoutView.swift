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
                    at: store.phase,
                    with: store.selectedExercise
                ) {
                    store.send(.resetButtonTapped)
                }
                .padding(.horizontal, 20)
                
                switch store.phase {
                case .selectWorkout:
                    Picker("workout",
                           selection: $store.selectedExercise.sending(\.exerciseChanged))
                    {
                        ForEach(Exercise.allCases, id: \.self) {
                            Text($0.title)
                                .font(.title)
                        }
                    }
                    .pickerStyle(.wheel)
                case .selectGrade:
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
                    store.send(.doneButtonTapped)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .opacity(store.phase == .selectWorkout
                                     ? 0
                                     : 1
                            )
                        
                        Text(store.phase == .selectWorkout
                             ? "완료"
                             : "\(store.selectedExercise.title) 시작하기"
                        )
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
    
    private let phase: WorkoutFeature.State.Phase
    private let exercise: Exercise
    private let resetAction: (() -> Void)
    
    var title: String {
        switch phase {
        case .selectWorkout:
            "지금 운동하시나요?"
        case .selectGrade:
            "\(exercise.title)"
        }
    }
    
    var description: String {
        switch phase {
        case .selectWorkout:
            "운동을 선택하세요."
        case .selectGrade:
            "목표 등급을 선택하세요."
        }
    }
    
    init(
        at phase: WorkoutFeature.State.Phase,
        with exercise: Exercise,
        _ resetAction: @escaping (() -> Void)
    ) {
        self.phase = phase
        self.exercise = exercise
        self.resetAction = resetAction
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 14) {
            
            HStack(spacing: 20) {
                Text(title)
                    .font(.title.bold())
                    .animation(.easeInOut(duration:0.7))
                    .contentTransition(.opacity)
                
                Spacer()
                
                if phase == .selectGrade {
                    Button {
                        resetAction()
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
