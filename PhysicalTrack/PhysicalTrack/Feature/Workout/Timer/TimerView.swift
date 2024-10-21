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
                    
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
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
                    
                    Spacer()
                }
                VStack{
                    Text("Timer")
                    Text(store.leftTime)
                        .font(.system(size: 40, weight: .bold))
                    
                    Text(String(store.record.count) + "개")
                        .font(.system(size: 40, weight: .bold))
                    
                    Button("종료") {
                        store.send(.quitButtonTapped)
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                store.send(.onAppear)
            }
            .overlay {
                if store.presentResult {
                    resultView
                }
            }
            
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
                
                Button {
                    store.send(.doneButtonTapped)
                } label: {
                    Text("완료")
                }
                
            }
            .background(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 300)
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

