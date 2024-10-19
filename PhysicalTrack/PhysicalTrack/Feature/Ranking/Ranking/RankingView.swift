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
                Button("순위 더보기") {
                    store.send(.rankingDetailButtonTapped)
                }
            }
            .navigationTitle("이번 주 순위")
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
