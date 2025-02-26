//
//  UserInfoView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import SwiftUI
import ComposableArchitecture

struct UserInfoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Bindable var store: StoreOf<UserInfoFeature>
    
    var body: some View {
        ScrollView {
            VStack {
                
                SectionView(key: "닉네임", value: store.userInfo.name) {
                    store.send(.editNicknameButtonTapped)
                }
                
                SectionView(key: "성별", value: store.userInfo.gender.title) {
                    store.send(.editGenderButtonTapped)
                }
                
                SectionView(key: "출생연도", value: String(store.userInfo.yearOfBirth)) {
                    store.send(.editBirthButtonTapped)
                }
                .padding(.top, 3)
                
                Button {
                    store.send(.withdrawButtonTapped)
                } label: {
                    Text("탈퇴하기")
                        .foregroundStyle(.ptGray)
                }
                .padding(.top, 80)
            }
            
            .padding(.horizontal, 28)
        }
        .background(.ptBackground)
        .navigationTitle("계정 정보")
        .navigationBarTitleDisplayMode(.inline)
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
//        .navigationDestination(
//            item: $store.scope(
//                state: \.destination?.editNickname,
//                action: \.destination.editNickname)
//        ) { store in
//            EditNicknameView(store: store)
//        }
//        .navigationDestination(
//            item: $store.scope(
//                state: \.destination?.editGender,
//                action: \.destination.editGender)
//        ) { store in
//            EditGenderView(store: store)
//        }
//        .navigationDestination(
//            item: $store.scope(
//                state: \.destination?.editBirth,
//                action: \.destination.editBirth)
//        ) { store in
//            EditBirthView(store: store)
//        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

fileprivate struct SectionView: View {
    
    let key: String
    let value: String
    var action: (() -> Void)
    
    fileprivate init(key: String, value: String, action: @escaping (() -> Void)) {
        self.key = key
        self.value = value
        self.action = action
    }
    
    var body: some View {
        Group {
            Text(key)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.ptGray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
            
            
            HStack {
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.ptWhite)
                
                Spacer()
                
                Button {
                    action()
                } label: {
                    Text("수정")
                        .font(.headline)
                        .foregroundStyle(.ptPoint)
                }
            }
            .padding(.top, 2)
        }
        .background(.ptBackground)
        
    }
}

#Preview {
    NavigationStack {
        UserInfoView(store: .init(initialState: .init(), reducer: {
            UserInfoFeature()
        }))
    }
}
