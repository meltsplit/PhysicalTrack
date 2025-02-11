//
//  RunningView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/9/25.
//

import SwiftUI
import ComposableArchitecture

struct RunningView: View {
    @Bindable var store: StoreOf<RunningFeature>
    
    var body: some View {
        VStack {
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

