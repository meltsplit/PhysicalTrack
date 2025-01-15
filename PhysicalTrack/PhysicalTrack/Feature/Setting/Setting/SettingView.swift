//
//  SettingView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    @Bindable var store : StoreOf<SettingFeature>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            
            ScrollView {
                VStack {
                    Button {
                        store.send(.userInfoTapped)
                    } label: {
                        VStack {
                            HStack {
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.all, 10)
                                    .frame(width: 60, height: 60)
                                    .background(.ptPoint)
                                    .tint(.ptLightGray01)
                                    .clipShape(Circle())
                                
                                Text("장석우님")
                                    .font(.title2)
                                    .bold()
                                    .padding(.leading, 16)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                
                            }
                        }
                        .padding(.vertical, 36)
                        .foregroundStyle(.ptWhite)
                        .padding(.horizontal, 28)
                        .background(.ptBackground)
                    }
                    
                    Spacer()
                        .frame(height: 4)
                    
                    VStack(spacing: 0) {
                        ForEach(store.list, id: \.self) { type in
                            Button {
                                store.send(.listTapped(type))
                            }
                            label: {
                                HStack {
                                    Image(systemName: type.systemImage ?? "")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                    
                                    Text(type.title)
                                        .padding(.leading, 8)
                                    
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 22)
                                .foregroundStyle(.ptWhite)
                                .padding(.horizontal, 28)
                                .background(.ptBackground)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    
                }
                .background(.black)
                
            }
            .background(.ptBackground)
            .navigationTitle("설정")
            .sheet(
                item: $store.scope(state: \.tutorial, action: \.tutorial)
            ) { store in
                TutorialView(store: store)
            }
            .sheet(
                item: $store.scope(state: \.web, action: \.web)
            ) { store in
                PTWebView(store: store)
            }
        } destination: { store in
            switch store.case {
            case let .userInfo(store):
                UserInfoView(store: store)
                    .toolbar(.hidden, for: .tabBar)
            }
            
        }
        
        
    }
}

#Preview {
    NavigationStack {
        SettingView(
            store: .init(initialState: SettingFeature.State()) {
                SettingFeature()
            }
        )
    }
}
