//
//  HeaderTabView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import SwiftUI
import ComposableArchitecture

struct HeaderTabView<Item: HeaderItemType>: View {

    @Bindable var store: StoreOf<HeaderTabFeature<Item>>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(store.items, id: \.self) { item in
                    Button {
                        store.send(.selectItem(item))
                    } label: {
                        Text(item.title)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundColor(.ptWhite)
                            .background(.ptBackground)
                            .bold()
                            .frame(height: 40)
                    }
                     .buttonStyle(PlainButtonStyle())
                }
            }
            
            
            Rectangle()
                .foregroundColor(.ptPoint)
                .frame(width: UIScreen.main.bounds.width / CGFloat(store.items.count), height: 3)
                .offset(.init(width: CGFloat(store.selectedIndex) * UIScreen.main.bounds.width / CGFloat(store.items.count) , height: 0))
                .animation(.easeInOut, value: store.selectedIndex)
        }
        
        .background(.ptBackground)
    }
}


