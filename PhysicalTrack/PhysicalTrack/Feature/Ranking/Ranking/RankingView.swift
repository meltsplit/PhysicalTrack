//
//  RankingView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct RankingView: View {
    
    @Bindable var store : StoreOf<RankingFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            Group {
                if store.pushUpTop3.isEmpty {
                    emptyView
                } else {
                    ScrollView {
                        RankingTop3View(store: store,
                                        type: .consistency,
                                        description: "일째 운동 중",
                                        rankings: store.consistencyTop3)
                        
                        Spacer().frame(height: 14)
                        
                        RankingTop3View(store: store,
                                        type: .pushUp,
                                        description: "회",
                                        rankings: store.pushUpTop3)
                    }
                }
            }
            .background(.ptBackground)
            .alert($store.scope(state: \.alert, action: \.alert))
            .navigationTitle("이번 주 순위")
            .onAppear {
                store.send(.onAppear)
            }
        } destination: { store in
            switch store.case {
            case let .rankingDetail(store):
                RankingDetailView(store: store)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(.hidden, for: .tabBar)
                
            case let .web(store):
                PTWebView(store: store)
            }
        }
        
    }
    
    var emptyView: some View {
        VStack(spacing: 18) {
            
            Spacer()
                .frame(height: 170)
            
            Text("아직 순위에 등록된 유저가 없어요")
                .font(.title2)
                .multilineTextAlignment(.center)
                .bold()
            
            Text("지금 운동하면 1위를 차지할 수 있어요!")
                .font(.headline)
                .foregroundStyle(.ptGray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Button("운동 하러가기") {
                store.send(.workoutButtonTapped)
            }
            .ptBottomButtonStyle()
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

fileprivate struct RankingTop3View: View {
    
    let store: StoreOf<RankingFeature>
    let type: RankingType
    let description: String
    let rankings: [any RankingRepresentable]
    
    var body: some View {
        VStack {
            HStack {
                Text("\(type.title) Top 3")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.ptWhite)
                    .padding(.bottom, 20)
                
                Spacer()
            }
            
            if rankings.isEmpty {
                emptyView
            } else {
                LazyVStack(spacing: 20) {
                    ForEach(rankings, id: \.userID) { data in
                        HStack {
                            Text(String(data.rank))
                                .foregroundStyle(.ptLightGray01)
                                .fontWeight(.semibold)
                            
                            Text(data.name)
                                .foregroundStyle(.ptWhite)
                            Spacer()
                            Text("\(data.value)\(description)")
                                .foregroundStyle(.ptLightGray01)
                        }
                    }
                }
                
                Button {
                    store.send(.rankingDetailButtonTapped(type))
                } label: {
                    Text("순위 더보기")
                        .font(.body.bold())
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .foregroundStyle(.ptWhite)
                        .background(.ptDarkGray02)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .padding(.top, 20)
            }
        }
        .padding(18)
        .background(.ptDarkNavyGray)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    var emptyView: some View {
        VStack(spacing: 12) {
            
            Text("아직 순위에 등록된 유저가 없어요")
                .font(.headline)
                .multilineTextAlignment(.center)
                .bold()
            
            Text("지금 운동하면 1위를 차지할 수 있어요!")
                .font(.subheadline)
                .foregroundStyle(.ptGray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Button("운동 하러가기") {
                store.send(.workoutButtonTapped)
            }
            .ptBottomButtonStyle(
                .blue,
                .init(height: 48, font: .body.bold())
            )
            .frame(width: 160)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    RankingView(
        store: .init(initialState: RankingFeature.State()) {
            RankingFeature()
        }
    )
}
