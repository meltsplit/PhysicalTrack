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
                    ConsistencyRankingView(store: store)
                        .tag(RankingType.consistency)
                }
                
                if let store = store.scope(state: \.pushUp, action: \.pushUp) {
                    PushUpRankingView(store: store)
                        .tag(RankingType.pushUp)
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

struct ConsistencyRankingView: View {
    let store: StoreOf<ConsistencyRankingFeature>

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 6) {
                ForEach(store.ranking, id: \.self) { data in
                    Button {
                        store.send(.rankCellTapped(data.userId))
                    } label: {
                        HStack {
                            Text(String(data.rank))
                                .foregroundStyle(.ptLightGray01)
                                .fontWeight(.semibold)
                            
                            Text(data.name)
                                .foregroundStyle(.ptWhite)
                            
                            Spacer()
                            
                            Text("\(data.daysActive)일째 운동 중")
                                .foregroundStyle(.ptLightGray01)
                        }
                        .padding(12)
                        .background(.ptDarkNavyGray)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
            .padding(.all, 20)
        }
        
    }
}

struct PushUpRankingView: View {
    let store: StoreOf<PushUpRankingFeature>

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 6) {
                ForEach(store.ranking, id: \.self) { data in
                    Button {
                        store.send(.rankCellTapped(data.userId))
                    } label: {
                        HStack {
                            Text(String(data.rank))
                                .foregroundStyle(.ptLightGray01)
                                .fontWeight(.semibold)
                            
                            Text(data.name)
                                .foregroundStyle(.ptWhite)
                            
                            Spacer()
                            
                            Text("\(data.quantity)회")
                                .foregroundStyle(.ptLightGray01)
                        }
                        .padding(12)
                        .background(.ptDarkNavyGray)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
            .padding(.all, 20)
            
        }
        
        
    }
}

#Preview {
    RankingDetailView(
        store: .init(initialState: RankingDetailFeature.State(.consistency, [.stub1, .stub2, .stub3], [.stub1, .stub2, .stub3])) {
            RankingDetailFeature()
        }
    )
}
