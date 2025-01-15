//
//  EditGenderView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import SwiftUI
import ComposableArchitecture

struct EditGenderView: View {
    
    @Bindable var store: StoreOf<EditGenderFeature>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            Text("성별 수정하기")
                .font(.title)
                .bold()
                .padding(.top, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            
            Text("성별 맞춤 체력등급을 제공하는데 사용해요.")
                .font(.title3)
                .foregroundStyle(.gray)
                .padding(.top, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(store.gender.title)
                .font(.title)
                .bold()
                .padding(.top, 40)
            
            Spacer()
            
            Button("완료") {
                store.send(.doneButtonTapped)
            }
            .ptBottomButtonStyle()
            
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
        EditGenderView(store: .init(initialState: .init(), reducer: {
            EditGenderFeature()
        }))
    }
}

