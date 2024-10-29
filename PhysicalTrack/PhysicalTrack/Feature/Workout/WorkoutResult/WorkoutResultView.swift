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
         
                    
                    LazyVStack {
                        ForEach(store.criterias, id: \.self) { criteria in
                            HStack {
                                Text(criteria.grade.title)
                                Spacer()
                                Text(criteria.description)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 400)
                    
                }
            }
            Spacer()
            
            Button("기록 확인하기") {
                store.send(.goStatisticsButtonTapped)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .onAppear {
            store.send(.onAppear)
        }
    }
}

fileprivate struct ReesultTitleView : View {
    
    private let grade: Grade
    
    init(grade: Grade) {
        self.grade = grade
    }
    
    var body: some View {
        
        Group{
            switch grade {
            case .elite:
                Text("특급 입니다🎉")
            case .grade1:
                Text("1등급 입니다🎉")
            case .grade2:
                Text("2등급 입니다🎉")
            case .grade3:
                Text("3등급 입니다🎉")
            case .failed:
                Text("불합격 입니다😅")
            }
        }
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
