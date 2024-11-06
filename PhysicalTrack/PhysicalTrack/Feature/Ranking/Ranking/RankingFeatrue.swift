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
        @Shared(.appStorage(.accessToken)) var accessToken = ""
        var path = StackState<Path.State>()
        var consistency: [ConsistencyRankingResponse] = []
        var pushUp: [PushUpRankingResponse] = []
        var consistencyTop3: [ConsistencyRankingResponse] = []
        var pushUpTop3: [PushUpRankingResponse] = []
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case pushUpRankingResponse(Result<[PushUpRankingResponse], Error>)
        case consistencyRankingResponse(Result<[ConsistencyRankingResponse], Error>)
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
        case web(PTWebFeature)
    }
   
    
    @Dependency(\.rankingClient) private var rankingClient
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                state.consistency = [.stub1, .stub2, .stub3, .stub4, .stub5, .stub6] //TODO: 꾸준함 랭킹 삭제
                state.consistencyTop3 = state.consistency.prefix(3).map { $0 }
                return .merge(
                    //TODO: 꾸준함 랭킹 나오면 반영
//                    .run { [state = state] send in
//                        await send(.consistencyRankingResponse(Result { try await rankingClient.fetchConsistency(state.accessToken)}))
//                    },
                    .run { [state = state] send in
                        await send(.pushUpRankingResponse(Result { try await rankingClient.fetchPushUp(state.accessToken)}))
                    }
                )
            case let .rankingDetailButtonTapped(type):
                state.path.append(.rankingDetail(RankingDetailFeature.State(type, state.consistency, state.pushUp)))
                return .none
            case let .path(.element(id: _, action: .rankingDetail(.rankCellTapped(userID)))):
                state.path.append(.web(PTWebFeature.State(url: "https://physical-t-7jce.vercel.app", targetUserID: userID)))
                return .none
                
            case let .pushUpRankingResponse(.success(response)):
                state.pushUp = response
                state.pushUpTop3 = Array(response.prefix(3))
                return .none
            case let .consistencyRankingResponse(.success(response)):
                state.consistency = response
                state.consistencyTop3 = Array(response.prefix(3))
                return .none
                
            case .pushUpRankingResponse(.failure), .consistencyRankingResponse(.failure):
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
