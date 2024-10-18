//
//  RankingView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct RankingView: View {
    let store : StoreOf<RankingFeature>
    
    var body: some View {
        Text("Ranking")
    }
}

#Preview {
    RankingView(
        store: .init(initialState: RankingFeature.State()) {
            RankingFeature()
        }
    )
}
