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
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            
            ZStack {
                VStack {
                    
                    ZStack {
                        
                        HStack {

                            Spacer()
                            
                            VStack(spacing: 8) {
                                
                                Text("시간")
                                    .bold()
                                    .foregroundStyle(.ptGray)
                                
                                Text(store.record.currentSeconds.to_mmss)
                                    .font(.title3.bold())
                                
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                
                VStack{
                    Spacer()
                    
                    Text(String("\(Int(store.record.currentDistance)) m"))
                        .font(.system(size: 60, weight: .bold))
                        .contentTransition(.numericText(value: store.record.currentDistance))
                        .animation(.snappy, value: store.record.currentDistance)
                    
                    Spacer()
                    
                    Button("일시정지") {
                        store.send(.pauseButtonTapped)
                    }
                    .foregroundStyle(.ptGray)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                store.send(.onAppear)
            }
            .overlay {
                if let store = store.scope(state: \.ready, action: \.ready) {
                    WorkoutReadyView(store: store)
                }
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            
        } destination: { store in 
            RunningResultView(store: store)
        }
        
    }
}

#Preview {
    RunningView(store: .init(
        initialState: RunningFeature.State(record: .init(for: .elite)), reducer: {
            RunningFeature()
        }))
}

