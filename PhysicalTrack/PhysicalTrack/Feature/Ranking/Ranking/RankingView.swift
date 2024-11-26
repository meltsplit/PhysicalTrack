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
                    .foregroundStyle(.ptWhite)
                    .bold()
                    .padding(.bottom, 20)
                
                Spacer()
            }
            
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
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundStyle(.ptWhite)
                    .background(.ptDarkGray02)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .padding(.top, 20)
        }
        .padding(18)
        .background(.ptDarkNavyGray)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

#Preview {
    RankingView(
        store: .init(initialState: RankingFeature.State()) {
            RankingFeature()
        }
    )
}
