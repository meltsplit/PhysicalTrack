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
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(.black)
                            .bold()
                            .frame(height: 40)
                    }
                     .buttonStyle(PlainButtonStyle())
                }
            }
            
            
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: UIScreen.main.bounds.width / CGFloat(store.items.count), height: 4)
                .offset(.init(width: CGFloat(store.selectedIndex) * UIScreen.main.bounds.width / CGFloat(store.items.count) , height: 0))
                .animation(.easeInOut, value: store.selectedIndex)
        }
        
        .background(.black)
    }
}


