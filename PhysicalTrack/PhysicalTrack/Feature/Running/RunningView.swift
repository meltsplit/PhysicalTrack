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
                            VStack(spacing: 8) {
                                
                                Text("페이스")
                                    .bold()
                                    .foregroundStyle(.ptGray)
                                
                                Button {
                                    store.send(.muteButtonTapped)
                                } label: {
                                    Image(systemName: store.isMute
                                          ? "speaker.slash.fill"
                                          : "speaker.fill"
                                    )
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(.ptWhite)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 8) {
                                
                                Text("시간")
                                    .bold()
                                    .foregroundStyle(.ptGray)
                                
                                Text(store.currentSeconds.to_mmss)
                                    .font(.title3.bold())
                                
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                
                VStack{
                    Spacer()
                    
                    Text(String("\(Int(store.totalDistance * 1000)) m"))
                        .font(.system(size: 60, weight: .bold))
                        .contentTransition(.numericText(value: store.totalDistance))
                        .animation(.snappy, value: store.totalDistance)
                    
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
                if store.readyLeftSeconds > 0 {
                    VStack {
                        Text("\(store.readyLeftSeconds)")
                            .font(.system(size: 80))
                            .fontWeight(.black)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.8))
                }
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            
        } destination: { store in
            WorkoutResultView(store: store)
        }
        
    }
}

#Preview {
    RunningView(store: .init(
        initialState: RunningFeature.State(), reducer: {
            RunningFeature()
        }))
}

