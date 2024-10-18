//
//  TimerView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct TimerView: View {
    @Bindable var store: StoreOf<TimerFeature>
    
    var body: some View {
        VStack{
            Text("Timer")
            Text("시간: " + String(store.leftTime))
            Text("개수: " + String(store.count))
            Button("종료") {
                store.send(.quitButtonTapped)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    TimerView(store: .init(initialState: TimerFeature.State(), reducer: {
        TimerFeature()
    }))
}
