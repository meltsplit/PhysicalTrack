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
            Button("횟수 카운팅") {
                store.send(.counting)
            }
            Button("종료") {
                store.send(.quitButtonTapped)
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
        

    }
    
    @State private var isAnimation = false
    var resultView: some View {
        VStack {
            Spacer()
            
            
            VStack {
                HStack {
                    Picker("", selection: $store.count.sending(\.selectCount)) {
                        ForEach((0...200), id: \.self) {
                            Text(String($0))
                                .padding(.vertical, 20)
                        }
                    }
                    .pickerStyle(.wheel)
                    Text("회")
                }
                .padding(.horizontal, 80)
                
                Button("완료") {
                    store.send(.doneButtonTapped)
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
    TimerView(store: .init(initialState: TimerFeature.State(), reducer: {
        TimerFeature()
    }))
}
