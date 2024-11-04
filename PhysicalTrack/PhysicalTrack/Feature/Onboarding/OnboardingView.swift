//
//  OnboardingView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    @Bindable var store : StoreOf<OnboardingFeature>
    @FocusState var nameTextFieldFocused: Bool
    
    var body: some View {
        VStack {
        
            ProgressView(value: store.progress)
                .frame(height: 3)
                .frame(maxWidth: .infinity)
                .background(.ptGray)
                .tint(.ptPoint)
                .padding(.horizontal, 20)
                .animation(.easeInOut, value: store.progress)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            TabView {
                switch store.currentStep {
                case .yearOfBirth: yearOfBirthView
                case .name: nameView
                case .gender: genderView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ptBackground)
            
        }
        .background(.ptBackground)

    }
    
    var nameView: some View {
        VStack {
            
            Text("어떻게 불러 드릴까요?")
                .font(.title)
                .bold()
                .padding(.top, 60)
            
            Text("서비스 내에서 사용될 닉네임이에요.")
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(.top, 20)
            
            TextField("닉네임", text: $store.name.sending(\.nameChanged))
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .focused($nameTextFieldFocused)
                .padding(.top, 40)
            
            
            Spacer()
            
            Button("계속하기") {
                store.send(.continueButtonTapped)
            }
            .ptBottomButtonStyle()
            .disabled(store.name.isEmpty)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .onAppear {
                nameTextFieldFocused = true
            }
            
        }
        .background(.ptBackground)
    }
    
    var genderView: some View {
        VStack {
            HStack {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.ptWhite)
                        
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            
            Text("성별을 선택해 주세요.")
                .font(.title)
                .bold()
                .padding(.top, 60)
            
            Text("성별 맞춤 체력등급을 제공하는데 사용해요.")
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(.top, 20)
            
            Text(store.gender.title)
                .font(.title)
                .bold()
                .padding(.top, 40)
            
            Spacer()
            
            Button("계속하기") {
                store.send(.continueButtonTapped)
            }
            .ptBottomButtonStyle()
            .padding(.horizontal, 20)
            
            Group {
                Picker("", selection: $store.gender.sending(\.genderChanged)) {
                    ForEach((Gender.allCases), id: \.self) {
                        Text(String($0.title))
                            .font(.title2)
                            .bold()
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 200)
                .frame(maxWidth: .infinity)
            }
            .backgroundStyle(.gray)
        }
        .background(.ptBackground)
    }
    
    var yearOfBirthView: some View {
        VStack {
            
            HStack {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.ptWhite)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            
            Text("출생 연도를 선택해 주세요.")
                .font(.title)
                .bold()
                .padding(.top, 80)
            
            Text("연령대 맞춤 체력등급을 제공하는데 사용해요.")
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(.top, 20)
            
            Text(String(store.yearOfBirth))
                .font(.title)
                .bold()
                .padding(.top, 40)
                .contentTransition(.numericText(value: Double(store.yearOfBirth)))
                .animation(.snappy, value: store.yearOfBirth)
            
            Spacer()
            
            Button("회원가입") {
                store.send(.continueButtonTapped)
            }
            .ptBottomButtonStyle()
            .padding(.horizontal, 20)
            
            Picker("", selection: $store.yearOfBirth.sending(\.yearOfBirthChanged)) {
                ForEach((1950...2030), id: \.self) {
                    Text(String($0))
                        .font(.title2)
                        .bold()
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .backgroundStyle(.gray)
        }
        .background(.ptBackground)
    }
}

#Preview {
    OnboardingView(
        store: .init(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }
    )
}
