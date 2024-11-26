//
//  RankingDetailFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RankingDetailFeature {
    
    @ObservableState
    struct State {
        var selectedTab: RankingType
        var consistency: RankingDetailListFeature.State? = .init()
        var pushUp: RankingDetailListFeature.State? = .init()
        var headerTab: HeaderTabFeature<RankingType>.State? = .init(selectedItem: .consistency)
        
        init(_ selectedTab: RankingType, _ consistency: [ConsistencyRankingResponse], _ pushUp: [PushUpRankingResponse]) {
            self.selectedTab = selectedTab
            self.consistency = RankingDetailListFeature.State(ranking: consistency)
            self.pushUp = RankingDetailListFeature.State(ranking: pushUp)
            self.headerTab = HeaderTabFeature<RankingType>.State(selectedItem: selectedTab)
        }
    }
    
    enum Action {
        case selectTab(RankingType)
        case consistency(RankingDetailListFeature.Action)
        case pushUp(RankingDetailListFeature.Action)
        case headerTab(HeaderTabFeature<RankingType>.Action)
        case rankCellTapped(Int)
        case path
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case let .selectTab(type):
                return .send(.headerTab(.selectItem(type)))
            case let .consistency(.rankCellTapped(userID)):
                return .send(.rankCellTapped(userID))
                
            case let .pushUp(.rankCellTapped(userID)):
                return .send(.rankCellTapped(userID))
            case let .headerTab(.selectItem(type)):
                state.selectedTab = type
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.consistency, action: \.consistency) {
            RankingDetailListFeature()
        }
        .ifLet(\.pushUp, action: \.pushUp) {
            RankingDetailListFeature()
        }
        .ifLet(\.headerTab, action: \.headerTab) {
            HeaderTabFeature<RankingType>()
        }
        
        
        
    }
}
