//
//  RankingDetailView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import SwiftUI
import ComposableArchitecture

struct RankingDetailView: View {
    
    @Bindable var store: StoreOf<RankingDetailFeature>

    var body: some View {
        VStack {
            if let store = store.scope(state: \.headerTab, action: \.headerTab) {
                HeaderTabView<RankingType>(store: store)
            }
            
            TabView(selection: $store.selectedTab.sending(\.selectTab)) {
                
                if let store = store.scope(state: \.consistency, action: \.consistency) {
                    LazyVStack {
                        ForEach(store.ranking, id: \.self) { data in
                            HStack {
                                Text(String(data.rank))
                                Text(data.name)
                                Spacer()
                                Text(String(data.daysActive))
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .tag(RankingType.consistency)
                }
                
                if let store = store.scope(state: \.pushUp, action: \.pushUp) {
                    LazyVStack {
                        ForEach(store.ranking, id: \.self) { data in
                            HStack {
                                Text(String(data.rank))
                                Text(data.name)
                                Spacer()
                                Text(String(data.quantity))
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .tag(RankingType.pushUp)
                }
            }
            .animation(.default, value: store.selectedTab)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    RankingDetailView(
        store: .init(initialState: RankingDetailFeature.State(.consistency, .mock)) {
            RankingDetailFeature()
        }
    )
}
