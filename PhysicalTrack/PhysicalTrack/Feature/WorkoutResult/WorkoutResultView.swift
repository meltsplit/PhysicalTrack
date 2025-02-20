//
//  WorkoutResultView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct WorkoutResultView: View {
    
    let store: StoreOf<WorkoutResultFeature>
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ResultTitleView(grade: store.grade)
                        .padding(.vertical, 40)
                    
                    HStack {
                        switch store.state {
                        case .pushUp:
                            if let store = store.scope(
                                state: \.pushUp,
                                action: \.pushUp
                            ) {
                                ResultPushUpView(store: store)
                            }
                        case .running:
                            if let store = store.scope(
                                state: \.running,
                                action: \.running
                            ) {
                                ResultRunningView(store: store)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .background(.ptDarkNavyGray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 24)
                    
                    LazyVStack {
                        HStack {
                            Text("등급표")
                                .font(.title3)
                                .bold()
                            
                            Spacer()
                        }
                        .padding(.bottom, 14)
                        
                        ForEach(store.criterias) { criteria in
                            HStack {
                                Text(criteria.grade.title)
                                Spacer()
                                Text(criteria.description)
                            }
                            .padding(.vertical, 10)
                            .foregroundStyle(store.grade == criteria.grade ? .ptPoint : .ptLightGray01)
                        }
                        .padding(.horizontal, 8)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                    .background(.ptDarkNavyGray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                    
                    
                }
            }
            Spacer()
            
            PTButton("기록 확인하기") {
                store.send(.goStatisticsButtonTapped)
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .navigationTitle("결과보기")
        .onAppear {
            store.send(.onAppear)
        }
    }
}

fileprivate struct ResultTitleView : View {
    
    private let grade: Grade
    private var emoji: String { grade == .failed ? "😅" : "🎉" }
    private var highlightColor: Color { grade == .failed ? .ptRed : .ptPoint }
    
    init(grade: Grade) {
        self.grade = grade
    }
    
    var body: some View {
        PTColorText(
            grade.title + " 입니다 " + emoji,
            at: grade.title,
            color: highlightColor
        )
        .font(.system(size: 32, weight: .bold))
    }
}

fileprivate struct ResultRunningView: View {
    
    let store: StoreOf<RunningResultFeature>
    
    var body: some View {
        Group {
            Spacer()
            VStack {
                Text("시간")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text(store.record.currentDuration.formatted(.time(pattern: .minuteSecond)))
                    .bold()
            }
            
            Spacer()
            VStack {
                Text("거리")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text("\(Int(store.record.targetDistance / 1000)) km")
                    .bold()
            }
            Spacer()
            
            VStack {
                Text("속도")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text(String(format: "%0.2f", store.record.speed))
                    .bold()
            }
            Spacer()
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

fileprivate struct ResultPushUpView: View {
    
    let store: StoreOf<PushUpResultFeature>
    
    var body: some View {
        Group {
            Spacer()
            VStack {
                Text("시간")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text(String(store.record.duration.components.seconds))
                    .bold()
            }
            
            Spacer()
            VStack {
                Text("횟수")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text(String(store.record.count))
                    .bold()
            }
            Spacer()
            
            VStack {
                Text("페이스")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text(String(format: "%0.2f", store.record.pace))
                    .bold()
            }
            Spacer()
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}


#Preview {
    NavigationStack {
        WorkoutResultView(
            store: Store(
                initialState: WorkoutResultFeature.State.pushUp(.init(record: .init(for: .elite)))
            ) {
                WorkoutResultFeature()
            }
        )
    }
}
