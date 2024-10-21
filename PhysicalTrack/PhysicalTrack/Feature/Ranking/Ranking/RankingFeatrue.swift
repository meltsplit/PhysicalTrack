//
//  RankingFeatrue.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RankingFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var ranking : RankingResponse = .empty
        var consistencyTop3: [ConsistencyRankingResponse] = []
        var pushUpTop3: [PushUpRankingResponse] = []
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case rankingResponse(Result<RankingResponse, Error>)
        case path(StackActionOf<Path>)
        case rankingDetailButtonTapped(RankingType)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert {
            case serverFail
        }
    }
    
    @Reducer
    enum Path {
        case rankingDetail(RankingDetailFeature)
        case statistics(StatisticsFeature)
    }
    

    
   
    
    @Dependency(\.rankingClient) private var rankingClient
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(
                        .rankingResponse(Result {
                            try await rankingClient.fetch().data
                        })
                    )
                    
                }
            case let .rankingDetailButtonTapped(type):
                state.path.append(.rankingDetail(RankingDetailFeature.State(type, state.ranking)))
                return .none
            case let .path(.element(id: _, action: .rankingDetail(.rankCellTapped(userID)))):
                state.path.append(.statistics(StatisticsFeature.State(userID)))
                return .none
                
            case let .rankingResponse(.success(response)):
                state.ranking = response
                state.consistencyTop3 = Array(response.consistencyRanking.prefix(3))
                state.pushUpTop3 = Array(response.pushUpRanking.prefix(3))
                return .none
                
            case .rankingResponse(.failure):
                state.alert = AlertState(
                    title: { TextState("서버 오류가 발생했습니다.") },
                    actions: { 
                        ButtonState(
                            role: .cancel,
                            label: { TextState("확인")}
                        )
                    },
                    message: { TextState("잠시 후 다시 시도해주세요") }
                )
                return .none
                    
            case .path:
                return .none
            case .alert(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.alert, action: \.alert)
    }
}
