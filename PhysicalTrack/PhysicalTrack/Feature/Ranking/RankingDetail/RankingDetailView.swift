//
//  RankingDetailView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import SwiftUI
import ComposableArchitecture

struct RankingDetailView: View {
    let store : StoreOf<RankingDetailFeature>
    
    var body: some View {
        Button("장석우 유저") {
            store.send(.userCellTapped)
        }
    }
}

#Preview {
    RankingDetailView(
        store: .init(initialState: RankingDetailFeature.State()) {
            RankingDetailFeature()
        }
    )
}
