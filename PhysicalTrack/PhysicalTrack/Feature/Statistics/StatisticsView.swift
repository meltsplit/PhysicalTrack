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
        SMWebView(url: "https://physical-t-p3n2.vercel.app")
            
    }
}

#Preview {
    StatisticsView(
        store: .init(initialState: StatisticsFeature.State()) {
            StatisticsFeature()
        }
    )
}
