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

extension HeaderTabFeature.State: Equatable {
    static func == (lhs: HeaderTabFeature<Item>.State, rhs: HeaderTabFeature<Item>.State) -> Bool {
        AnyHashable(lhs.selectedItem) == AnyHashable(rhs.selectedItem)
        && lhs.selectedIndex == rhs.selectedIndex
    }
}

@Reducer
struct HeaderTabFeature<Item: HeaderItemType> {
    
    @ObservableState
    struct State {
        var selectedItem: Item
        var items = Item.allCases
        var selectedIndex: Int { selectedItem.rawValue }
        
        init(
            selectedItem: Item
        ) {
            self.selectedItem = selectedItem
        }
    }
    
    enum Action {
        case selectItem(Item)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case let .selectItem(item):
                state.selectedItem = item
                return .none
            }
        }
    }
}
