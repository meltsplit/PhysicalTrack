//
//  TimerView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct TimerView: View {
    let store: StoreOf<TimerFeature>
    
    var body: some View {
        Text("Timer")
    }
}

#Preview {
    TimerView(store: .init(initialState: TimerFeature.State(), reducer: {
        TimerFeature()
    }))
}
