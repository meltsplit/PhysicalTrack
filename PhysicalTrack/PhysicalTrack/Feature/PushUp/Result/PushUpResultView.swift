//
//  PushUpResultView.swift
//  PhysicalTrack
//
//  Created by MELT on 6/9/25.
//

import SwiftUI
import ComposableArchitecture

struct PushUpResultView: View {
    
    let store: StoreOf<PushUpResultFeature>
    
    var body: some View {
        WorkoutResultView(
            store: store.scope(state: \.result, action: \.result),
            infoView: PushUpResultInfoView(store: store)
        )
    }
}

fileprivate struct PushUpResultInfoView: View {
    
    let store: StoreOf<PushUpResultFeature>
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("시간")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text(String(store.record.duration.components.seconds))
                    .bold()
            }
            
            Spacer()
            VStack {
                Text("횟수")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text(String(store.record.count))
                    .bold()
            }
            Spacer()
            
            VStack {
                Text("페이스")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text(String(format: "%0.2f", store.record.pace))
                    .bold()
            }
            Spacer()
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}


#Preview {
    PushUpResultView(
        store: Store(
            initialState: PushUpResultFeature.State(record: .stub())
        ) {
            PushUpResultFeature()
        }
    )
}
