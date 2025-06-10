//
//  TutorialView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/25/24.
//

import SwiftUI
import ComposableArchitecture

struct TutorialView: View {
    @Bindable var store: StoreOf<TutorialFeature>
    
    
    var body: some View {
        VStack {
            TabView(selection: $store.currentModel.sending(\.tabChanged)) {
                ForEach(store.tutorialModels, id: \.self) { model in
                    TutorialStepView(state: model)
                }
            }
            .tabViewStyle(.page)
            
            PTButton {
                store.send(.confirmButtonTapped)
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 14, height: 14)
                    
                    Text("운동 시작하기")
                }
            }
            .opacity(store.isLastModel
                     ? 1
                     : 0
            )
        }
        .padding(.horizontal, 20)
    }
    
    
}

fileprivate struct TutorialStepView: View {
    
    let state: TutorialModel
    
    var body: some View {
        VStack(spacing: 10){
            Text(state.title)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            
            Image(state.image)
                .resizable()
                .scaledToFit()
            
            Text(state.description)
                .font(.headline)
                .foregroundStyle(.ptGray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    TutorialView(store: .init(initialState: TutorialFeature.State(tutorialModels: [.PushUp.first, .PushUp.second, .PushUp.third]), reducer: {
        TutorialFeature()
    }))
}
