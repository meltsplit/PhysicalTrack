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
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            if let store = store.scope(state: \.headerTab, action: \.headerTab) {
                HeaderTabView<RankingType>(store: store)
            }
            
            TabView(selection: $store.selectedTab.sending(\.selectTab)) {
                
                if let store = store.scope(state: \.consistency, action: \.consistency) {
                    RankingDetailListView(store: store)
                        .tag(RankingType.consistency)
                }
                
                if let store = store.scope(state: \.pushUp, action: \.pushUp) {
                    RankingDetailListView(store: store)
                        .tag(RankingType.pushUp)
                }
                
                if let store = store.scope(state: \.running, action: \.running) {
                    RankingDetailListView(store: store)
                        .tag(RankingType.running)
                }
            }
            .animation(.default, value: store.selectedTab)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(.ptBackground)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label : {
                    Image(systemName: "chevron.left")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.ptWhite)
                }
                
            }
        }
    }
}

#Preview {
    RankingDetailView(
        store: .init(initialState: RankingDetailFeature.State(.consistency, [.stub1, .stub2, .stub3], [.stub1, .stub2, .stub3], [])) {
            RankingDetailFeature()
        }
    )
}
