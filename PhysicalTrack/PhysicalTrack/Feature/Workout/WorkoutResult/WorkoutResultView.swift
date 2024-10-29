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
                    ReesultTitleView(grade: store.record.grade)
                        .padding(.vertical, 40)
                    
                    HStack {
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
                        
                        ForEach(store.criterias, id: \.self) { criteria in
                            HStack {
                                Text(criteria.grade.title)
                                Spacer()
                                Text(criteria.description)
                            }
                            .padding(.vertical, 10)
                            .foregroundStyle(store.record.grade == criteria.grade ? .ptPoint : .ptLightGray01)
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
            
            Button("기록 확인하기") {
                store.send(.goStatisticsButtonTapped)
            }
            .ptBottomButtonStyle()
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

fileprivate struct ReesultTitleView : View {
    
    private let grade: Grade
    private var emoji: String { grade == .failed ? "😅" : "🎉" }
    private var higlightColor: Color { grade == .failed ? .ptRed : .ptPoint }
    
    init(grade: Grade) {
        self.grade = grade
    }
    
    var body: some View {
        PTColorText(
            grade.title + " 입니다 " + emoji,
            at: grade.title,
            color: higlightColor
        )
        .font(.system(size: 32, weight: .bold))
    }
}





#Preview {
    NavigationStack {
        WorkoutResultView(
            store: .init(initialState: WorkoutResultFeature.State(record: .init(for: .grade1))) {
                WorkoutResultFeature()
            }
        )
    }
}
