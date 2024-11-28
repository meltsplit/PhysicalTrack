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
        if store.ranking.isEmpty {
            emptyView
        } else {
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(store.ranking, id: \.userID) { data in
                        Button {
                            store.send(.rankCellTapped(data))
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
            
            Button("운동 하러가기") {
                store.send(.workoutButtonTapped)
            }
            .ptBottomButtonStyle()
            
            Spacer()
        }
        .padding(.horizontal, 20)
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
