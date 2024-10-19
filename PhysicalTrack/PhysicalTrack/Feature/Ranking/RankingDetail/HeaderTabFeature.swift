//
//  HeaderTabFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture

protocol HeaderItemType: Hashable, CaseIterable, RawRepresentable where RawValue == Int, Self.AllCases: RandomAccessCollection {
    var title: String { get }
}

@Reducer
struct HeaderTabFeature<Item: HeaderItemType> {
    
    @ObservableState
    struct State {
        var selectedItem: Item
        var items = Item.allCases
        var selectedIndex: Int = 0
        init(
            selectedItem: Item
        ) {
            self.selectedItem = selectedItem
        }
    }
    
    enum Action {
        case selectItem(Item)
        case barAnimation(Int)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case let .selectItem(item):
                return .send(.barAnimation(item.rawValue))
                
            case let .barAnimation(rawValue):
                state.selectedIndex = rawValue
                return .none
            }
        }
    }
}
