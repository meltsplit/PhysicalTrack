//
//  StatisticsView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/1/24.
//

import SwiftUI
import ComposableArchitecture

struct StatisticsView: View {
    
    @Bindable var store: StoreOf<StatisticsFeature>
    
    var body: some View {
        if let store = store.scope(state: \.web, action: \.web) {
            PTWebView(store: store)
        }
    }
}

#Preview {
    StatisticsView(store: .init(initialState: StatisticsFeature.State(), reducer: {
        StatisticsFeature()
    }))
}
