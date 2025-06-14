//
//  RunningResultView.swift
//  PhysicalTrack
//
//  Created by MELT on 6/10/25.
//

import SwiftUI
import ComposableArchitecture

struct RunningResultView: View {
    
    let store: StoreOf<RunningResultFeature>
    
    var body: some View {
        WorkoutResultView(
            store: store.scope(state: \.result, action: \.result),
            infoView: RunningResultInfoView(store: store)
        )
    }
}


fileprivate struct RunningResultInfoView: View {
    
    let store: StoreOf<RunningResultFeature>
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("시간")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text(store.record.currentDuration.formatted(.time(pattern: .minuteSecond)))
                    .bold()
            }
            
            Spacer()
            VStack {
                Text("거리")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text("\(Int(store.record.targetDistance / 1000)) km")
                    .bold()
            }
            Spacer()
            
            VStack {
                Text("속도")
                    .foregroundStyle(.ptLightGray01)
                
                Spacer().frame(height: 14)
                
                Text(String(format: "%0.2f", store.record.speed))
                    .bold()
            }
            Spacer()
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

