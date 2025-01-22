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
            TabView(selection: $store.selectedTab.sending(\.tabChanged)) {
                ForEach(TutorialFeature.Step.allCases, id: \.self) { step in
                    TutorialStepView(step: step)
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
            .opacity(store.selectedTab == .third
                     ? 1
                     : 0
            )
        }
        .padding(.horizontal, 20)
    }
    
    
}

fileprivate struct TutorialStepView: View {
    
    let step: TutorialFeature.Step
    
    private var title: String {
        switch step {
        case .first: "기기를 평평한 바닥에 놓아주세요."
        case .second: "팔굽혀펴기를 시작하세요."
        case .third: "횟수가 자동으로 측정됩니다."
        }
    }
    
    private var description: String {
        switch step {
        case .first: "카메라를 코와 일직선에 맞추세요."
        case .second: "기기와 2cm 이내의 간격으로 접근하세요."
        case .third: "근접 센서가 자동으로 횟수를 측정해줍니다."
        }
    }
    
    private var image: ImageResource {
        switch step {
        case .first: .tutorial1
        case .second: .tutorial2
        case .third: .tutorial3
        }
    }
    
    
    var body: some View {
        VStack(spacing: 10){
            Text(title)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            
            Image(image)
                .resizable()
                .scaledToFit()
            
            Text(description)
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
    TutorialView(store: .init(initialState: TutorialFeature.State(), reducer: {
        TutorialFeature()
    }))
}
