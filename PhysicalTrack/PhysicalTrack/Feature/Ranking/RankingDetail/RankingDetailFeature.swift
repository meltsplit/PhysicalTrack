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
        private var _ranking: RankingResponse = .init(consistencyRanking: [], pushUpRanking: [])
        var selectedTab: RankingType
        var consistency: ConsistencyRankingFeature.State? = .init()
        var pushUp: PushUpRankingFeature.State? = .init()
        var headerTab: HeaderTabFeature<RankingType>.State? = .init(selectedItem: .consistency)
        
        init(_ selectedTab: RankingType, _ ranking: RankingResponse) {
            self._ranking = ranking
            self.selectedTab = selectedTab
            self.consistency = ConsistencyRankingFeature.State(ranking: ranking.consistencyRanking)
            self.pushUp = PushUpRankingFeature.State(ranking: ranking.pushUpRanking)
            self.headerTab = HeaderTabFeature<RankingType>.State(selectedItem: .consistency)
        }
    }
    
    enum Action {
        case selectTab(RankingType)
        case consistency(ConsistencyRankingFeature.Action)
        case pushUp(PushUpRankingFeature.Action)
        case headerTab(HeaderTabFeature<RankingType>.Action)
        case rankCellTapped(Int)
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
            ConsistencyRankingFeature()
        }
        .ifLet(\.pushUp, action: \.pushUp) {
            PushUpRankingFeature()
        }
        .ifLet(\.headerTab, action: \.headerTab) {
            HeaderTabFeature<RankingType>()
        }
        
        
        
    }
}
