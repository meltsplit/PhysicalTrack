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
                        VStack(spacing: 14) {
                            RankingTop3View(store: store,
                                            type: .consistency,
                                            rankings: store.consistencyTop3)
                            
                            RankingTop3View(store: store,
                                            type: .pushUp,
                                            rankings: store.pushUpTop3)
                            
                            RankingTop3View(store: store,
                                            type: .running,
                                            rankings: store.runningTop3)
                            
                            Spacer().frame(height: 10)
                        }
                        .background(.black)
                    }
                    .background(.ptBackground)
                }
            }
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
            
            PTButton("운동 하러가기") {
                store.send(.workoutButtonTapped)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

fileprivate struct RankingTop3View: View {
    
    let store: StoreOf<RankingFeature>
    let type: RankingType
    let rankings: [any RankingRepresentable]
    
    var body: some View {
        VStack {
            HStack {
                Text("\(type.title) Top 3")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.ptWhite)
                    .padding(.top, 14)
                    .padding(.bottom, 20)
                
                Spacer()
            }
            
            if rankings.isEmpty {
                emptyView
            } else {
                LazyVStack {
                    ForEach(rankings, id: \.userID) { data in
                        RankingCell(
                            rank: data.rank,
                            name: data.name,
                            description: data.description()
                        )
                    }
                }
                
                Divider()
                    .padding(.top, 20)
                
                Button {
                    store.send(.rankingDetailButtonTapped(type))
                } label: {
                    HStack(spacing: 10) {
                        Text("순위 더 보기")
                            .font(.body)
                            .bold()

                        Image(systemName: "chevron.right")
                            
                    }
                    .foregroundStyle(.ptLightGray01)
                }
                .padding(.top, 20)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .background(.ptBackground)
        
    }
    
    var emptyView: some View {
        VStack(spacing: 12) {
            
            Text("아직 순위에 등록된 유저가 없어요")
                .font(.headline)
                .multilineTextAlignment(.center)
                .bold()
                .padding(.top, 12)
            
            Text("지금 운동하면 1위를 차지할 수 있어요!")
                .font(.subheadline)
                .foregroundStyle(.ptGray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            PTButton("운동 하러가기") {
                store.send(.workoutButtonTapped)
            }
            .frame(width: 160)
            .padding(.top, 10)
            
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
