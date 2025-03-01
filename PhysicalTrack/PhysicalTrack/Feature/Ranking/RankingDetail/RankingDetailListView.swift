//
//  RankingDetailListView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/26/24.
//

import SwiftUI
import ComposableArchitecture

struct RankingDetailListView: View {
    let store: StoreOf<RankingDetailListFeature>
    
    var body: some View {
        if store.ranking.isEmpty {
            emptyView
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(store.ranking, id: \.userID) { data in
                        Button {
                            store.send(.rankCellTapped(data))
                        } label: {
                            RankingCell(
                                rank: data.rank,
                                name: data.name,
                                description: data.description
                            )
                        }
                        .buttonStyle(PTPressedStyle())
                    }
                }
                .background(.ptBackground)
                .padding(.vertical, 20)
                .padding(.horizontal, 24)
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
            .padding(.top, 12)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    RankingDetailListView(
        store: .init(initialState:
                        RankingDetailListFeature.State(
                            ranking: [ConsistencyRankingResponse.stub1.toDomain(),
                                      ConsistencyRankingResponse.stub2.toDomain(),
                                      ConsistencyRankingResponse.stub3.toDomain()]
                        )
                    )
        {
            RankingDetailListFeature()
        }
    )
}
