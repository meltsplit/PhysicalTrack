//
//  StatisticsView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct PTWebView: View {
    let store : StoreOf<PTWebFeature>
    @Environment(\.presentationMode) var presentationMode
    private var isPresented: Bool { presentationMode.wrappedValue.isPresented }
    
    var backButton : some View {
            Button{
                store.send(.backButtonTapped)
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.ptWhite)
                }
            }
        }
    
    
    var body: some View {
        VStack {
            store.representableWebView
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: isPresented || store.canGoBack ? backButton : nil)
        .onAppear {
            store.send(.onAppear)
        }
            
    }
}

#Preview {
    PTWebView(
        store: .init(initialState: PTWebFeature.State(url: "https://github.com/")) {
            PTWebFeature()
        }
    )
}
