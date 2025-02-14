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
                    ResultTitleView(grade: store.record.evaluate())
                        .padding(.vertical, 40)
                    
                    HStack {
                        switch store.record {
                        case .pushUp(let record):
                            ResultPushUpView(record: record)
                        case .running(let record):
                            ResultRunningView(record: record)
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
                            .foregroundStyle(store.record.evaluate() == criteria.grade ? .ptPoint : .ptLightGray01)
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
    private let record: RunningRecord
    
    init(record: RunningRecord) {
        self.record = record
    }
    
    var body: some View {
        
        Spacer()
        VStack {
            Text("시간")
                .foregroundStyle(.ptLightGray01)
            
            Spacer().frame(height: 14)
            
            Text(record.totalSeconds.formatted(.time(pattern: .minuteSecond)))
                .bold()
        }
        
        Spacer()
        VStack {
            Text("거리")
                .foregroundStyle(.ptLightGray01)
            
            Spacer().frame(height: 14)
            
            Text("\(Int(record.targetDistance / 1000)) km")
                .bold()
        }
        Spacer()
        
        VStack {
            Text("속도")
                .foregroundStyle(.ptLightGray01)
            
            Spacer().frame(height: 14)
            
            Text(String(format: "%0.2f", record.speed))
                .bold()
        }
        Spacer()
    }
}

fileprivate struct ResultPushUpView: View {
    private let record: PushUpRecord
    
    init(record: PushUpRecord) {
        self.record = record
    }
    
    var body: some View {
        
        Spacer()
        VStack {
            Text("시간")
                .foregroundStyle(.ptLightGray01)
            
            Spacer().frame(height: 14)
            
            Text(String(record.duration.components.seconds))
                .bold()
        }
        
        Spacer()
        VStack {
            Text("횟수")
                .foregroundStyle(.ptLightGray01)
            
            Spacer().frame(height: 14)
            
            Text(String(record.count))
                .bold()
        }
        Spacer()
        
        VStack {
            Text("페이스")
                .foregroundStyle(.ptLightGray01)
            
            Spacer().frame(height: 14)
            
            Text(String(format: "%0.2f", record.pace))
                .bold()
        }
        Spacer()
    }
}


#Preview {
    NavigationStack {
        WorkoutResultView(
            store: Store(
                initialState: WorkoutResultFeature.State(
                    record: .running(.init(for: .elite))
                )
            ) {
                WorkoutResultFeature()
            }
        )
    }
}
