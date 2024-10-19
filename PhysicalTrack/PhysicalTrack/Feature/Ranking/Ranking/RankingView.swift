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
                
                Text("꾸준함 Top3")
                    .padding(.top, 80)
                
                LazyVStack {
                    ForEach(store.consistencyTop3, id: \.self) { data in
                        HStack {
                            Text(String(data.rank))
                            Text(data.name)
                            Spacer()
                            Text(String(data.daysActive))
                        }
                    }
                }
                
                .padding(.horizontal, 40)
                
                Button("순위 더보기") {
                    store.send(.rankingDetailButtonTapped(.consistency))
                }
                
                
                Text("팔굽혀펴기 Top3")
                    .padding(.top, 80)
                
                LazyVStack {
                    ForEach(store.pushUpTop3, id: \.self) { data in
                        HStack {
                            Text(String(data.rank))
                            Text(data.name)
                            Spacer()
                            Text(String(data.quantity))
                        }
                    }
                }
                
                .padding(.horizontal, 40)
                
                
                Button("순위 더보기") {
                    store.send(.rankingDetailButtonTapped(.pushUp))
                }
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            .navigationTitle("이번 주 순위")
            .onAppear {
                store.send(.onAppear)
            }
        } destination: { store in
            switch store.case {
            case .statistics(let store):
                StatisticsView(store: store)
            case .rankingDetail(let store):
                RankingDetailView(store: store)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
       
        
        
    }
}

#Preview {
    RankingView(
        store: .init(initialState: RankingFeature.State()) {
            RankingFeature()
        }
    )
}
