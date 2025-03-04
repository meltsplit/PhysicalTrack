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
    struct State: Equatable {
        var selectedTab: RankingType
        var consistency: RankingDetailListFeature.State? = .init()
        var pushUp: RankingDetailListFeature.State? = .init()
        var running: RankingDetailListFeature.State? = .init()
        var headerTab: HeaderTabFeature<RankingType>.State? = .init(selectedItem: .consistency)
        
        init(
            _ selectedTab: RankingType,
            _ consistency: [ConsistencyRankingResponse],
            _ pushUp: [PushUpRankingResponse],
            _ running: [RunningRankingResponse]
        ) {
            self.selectedTab = selectedTab
            self.consistency = RankingDetailListFeature.State(ranking: consistency.map { $0.toDomain() })
            self.pushUp = RankingDetailListFeature.State(ranking: pushUp.map { $0.toDomain() })
            self.running = RankingDetailListFeature.State(ranking: running.map { $0.toDomain() })
            self.headerTab = HeaderTabFeature<RankingType>.State(selectedItem: selectedTab)
        }
    }
    
    enum Action {
        case selectTab(RankingType)
        case consistency(RankingDetailListFeature.Action)
        case pushUp(RankingDetailListFeature.Action)
        case running(RankingDetailListFeature.Action)
        case headerTab(HeaderTabFeature<RankingType>.Action)
        case rankCellTapped(RankingModel)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case let .selectTab(type):
                return .send(.headerTab(.selectItem(type)))
            case .consistency(.rankCellTapped(let userID)):
                return .send(.rankCellTapped(userID))
            case .pushUp(.rankCellTapped(let userID)):
                return .send(.rankCellTapped(userID))
            case .running(.rankCellTapped(let userID)):
                return .send(.rankCellTapped(userID))
            case .consistency, .pushUp, .running:
                return .none
            case let .headerTab(.selectItem(type)):
                state.selectedTab = type
                return .none
            case .rankCellTapped:
                return .none
            }
        }
        .ifLet(\.consistency, action: \.consistency) {
            RankingDetailListFeature()
        }
        .ifLet(\.pushUp, action: \.pushUp) {
            RankingDetailListFeature()
        }
        .ifLet(\.running, action: \.running) {
            RankingDetailListFeature()
        }
        .ifLet(\.headerTab, action: \.headerTab) {
            HeaderTabFeature<RankingType>()
        }
    }
}
