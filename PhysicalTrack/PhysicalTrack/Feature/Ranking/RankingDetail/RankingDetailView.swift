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
            HeaderTabView<RankingType>(store: store.scope(state: \.headerTab, action: \.headerTab))
            
            TabView(selection: $store.selectedTab.sending(\.selectTab)) {
                
                RankingDetailListView(store: store.scope(state: \.consistency, action: \.consistency))
                    .tag(RankingType.consistency)
                
                
                RankingDetailListView(store: store.scope(state: \.pushUp, action: \.pushUp))
                    .tag(RankingType.pushUp)
                
                
                RankingDetailListView(store: store.scope(state: \.running, action: \.running))
                    .tag(RankingType.running)
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
