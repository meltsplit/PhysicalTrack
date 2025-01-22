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
    @State private var animationValue = 1.0
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            
            ZStack {
                VStack {
                    
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.ptPoint)
                            .overlay {
                                Image(systemName: "nose")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.white)
                                
                            }
                            .overlay(
                                Circle()
                                    .stroke(.blue)
                                    .frame(width: 60, height: 60)
                                    .scaleEffect(animationValue)
                                    .opacity(1 - (animationValue / 5))
                                    .animation(
                                        .easeIn(duration: 1),
                                        value: store.record.count
                                    )
                            )
                            .onChange(of: store.record.count) { _, _ in
                                animationValue = 1
                                withAnimation {
                                    animationValue = 5
                                }
                            }
                        
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
                                
                                Text(store.workoutLeftSeconds.to_mmss)
                                    .font(.title3.bold())
                                    
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                
                VStack{
                    Spacer()
                    
                    Text(String(store.record.count) + "개")
                        .font(.system(size: 60, weight: .bold))
                        .contentTransition(.numericText(value: Double(store.record.count)))
                        .animation(.snappy, value: store.record.count)
                    
                    Spacer()
                    
                    Button("종료") {
                        store.send(.quitButtonTapped)
                    }
                    .foregroundStyle(.ptGray)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .blur(radius: store.presentResult ? 5 : 0)
            .onAppear {
                store.send(.onAppear)
            }
            .overlay {
                if store.presentResult {
                    resultView
                }
            }
            .overlay {
                if store.readyLeftSeconds > 0 {
                    VStack {
                        Text("\(store.readyLeftSeconds)")
                            .font(.largeTitle)
                            .bold()
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
    
    @State private var isAnimation = false
    var resultView: some View {
        VStack {
            Spacer()
            
            
            VStack {
                HStack {
                    Picker("", selection: $store.record.count.sending(\.selectCount)) {
                        ForEach((0...200), id: \.self) {
                            Text(String($0))
                                .padding(.vertical, 20)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Text("회")
                }
                .padding(.horizontal, 80)
                
                PTButton("완료") {
                    store.send(.doneButtonTapped)
                } 
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 44)
                
            }
            .background(.ptDarkNavyGray)
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .cornerRadius(20, corners: .topLeft)
            .cornerRadius(20, corners: .topRight)
            .offset(y: isAnimation ? 0 : UIScreen.main.bounds.height)
            .animation(.easeInOut(duration: 0.3), value: isAnimation)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(.black.opacity(0.4))
        .onAppear {
            isAnimation = true
        }
    }
}

#Preview {
    TimerView(store: .init(initialState: TimerFeature.State(.init(for: .grade1)), reducer: {
        TimerFeature()
    }))
}

