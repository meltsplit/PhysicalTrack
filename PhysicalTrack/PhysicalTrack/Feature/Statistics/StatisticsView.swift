//
//  StatisticsView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct StatisticsView: View {
    let store : StoreOf<StatisticsFeature>
    
    var body: some View {
        Text("Statistics")
    }
}

#Preview {
    StatisticsView(
        store: .init(initialState: StatisticsFeature.State()) {
            StatisticsFeature()
        }
    )
}
