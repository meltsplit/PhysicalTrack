//
//  ResultView.swift
//  PhysicalTrack
//
//  Created by MELT on 6/9/25.
//

import SwiftUI

import ComposableArchitecture

struct WorkoutResultView<InfoView: View>: View {
    
    let store: StoreOf<WorkoutResultFeature>
    
    let infoView: InfoView
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ResultTitleView(grade: store.grade)
                        .padding(.vertical, 40)
                    
                    infoView
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


struct ResultTitleView : View {
    
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
