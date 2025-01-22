//
//  EditBirthView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import SwiftUI
import ComposableArchitecture

struct EditBirthView: View {
    
    @Bindable var store: StoreOf<EditUserInfoFeature>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {

            Text("출생연도 수정하기")
                .font(.title)
                .bold()
                .padding(.top, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            
            Text("연령대 맞춤 체력등급을 제공하는데 사용해요.")
                .font(.title3)
                .foregroundStyle(.gray)
                .padding(.top, 14)
                .frame(maxWidth: .infinity, alignment: .leading)

            
            Text(String(store.userInfo.yearOfBirth))
                .font(.title)
                .bold()
                .padding(.top, 40)
                .contentTransition(.numericText(value: Double(store.userInfo.yearOfBirth)))
                .animation(.snappy, value: store.userInfo.yearOfBirth)
            
            Spacer()
            
            Button("완료") {
                store.send(.doneButtonTapped)
            }
            .ptBottomButtonStyle()
            
            Picker("", selection: $store.userInfo.yearOfBirth.sending(\.yearOfBirthChanged)) {
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
    }
}

#Preview {
    NavigationStack {
        EditGenderView(store: .init(initialState: .init(userInfo: .stub), reducer: {
            EditUserInfoFeature()
        }))
    }
}






