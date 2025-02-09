//
//  RunningView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/9/25.
//

import SwiftUI
import ComposableArchitecture

struct RunningView: View {
    let store: StoreOf<RunningFeature>
    
    var body: some View {
        VStack {
            Button("권한요청") {
                store.send(.tapped)
            }
            Button("시작") {
                store.send(.start)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    RunningView(
        store: .init(initialState: RunningFeature.State()) {
            RunningFeature()
        }
    )
}

