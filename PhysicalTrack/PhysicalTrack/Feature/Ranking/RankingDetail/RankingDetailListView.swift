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
    let description: String

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 6) {
                ForEach(store.ranking, id: \.userID) { data in
                    Button {
                        store.send(.rankCellTapped(data.userID))
                    } label: {
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
    RankingDetailListView(
        store: .init(initialState:
                        RankingDetailListFeature.State(
                            ranking: [ConsistencyRankingResponse.stub1,
                                      ConsistencyRankingResponse.stub2,
                                      ConsistencyRankingResponse.stub3]
                        )
                    )
        {
            RankingDetailListFeature()
        },
        description: "일째 운동 중"
    )
}
