//
//  EditNicknameView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import SwiftUI
import ComposableArchitecture

struct EditNicknameView: View {
    
    @Bindable var store: StoreOf<EditUserInfoFeature>
    @Environment(\.dismiss) var dismiss
    @FocusState var nameTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            
            Text("닉네임 수정하기")
                .font(.title)
                .bold()
                .padding(.top, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            
            Text("서비스 내에서 사용될 닉네임이에요.")
                .font(.title3)
                .foregroundStyle(.gray)
                .padding(.top, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            
            TextField("닉네임", text: $store.userInfo.name .sending(\.nameChanged))
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .focused($nameTextFieldFocused)
                .padding(.top, 40)
            
            Divider()
                .overlay(nameTextFieldFocused ? .ptPoint : .ptGray)
                .frame(maxWidth: .infinity)
                .padding(.top, 2)
            
            Spacer()
            
            PTButton("완료") {
                store.send(.doneButtonTapped)
            }
            .loading(store.isLoading)
            .disabled(store.userInfo.name.isEmpty)
            .padding(.bottom, 20)
            .onAppear {
                nameTextFieldFocused = true
            }
            
        }
        .padding(.horizontal, 20)
        .background(.ptBackground)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label : {
                    Image(systemName: "chevron.left")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.ptWhite)
                }
                
            }
        }
        .disabled(store.isLoading)
    }
}

#Preview {
    NavigationStack {
        EditNicknameView(store: .init(initialState: .init(userInfo: .stub), reducer: {
            EditUserInfoFeature()
        }))
    }
}
