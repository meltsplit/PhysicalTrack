//
//  RankingFeature.swift
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
        var consistency: [ConsistencyRankingResponse] = []
        var pushUp: [PushUpRankingResponse] = []
        var running: [RunningRankingResponse] = []
        var consistencyTop3: [ConsistencyRankingResponse] = []
        var pushUpTop3: [PushUpRankingResponse] = []
        var runningTop3: [RunningRankingResponse] = []
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case workoutButtonTapped
        case pushUpRankingResponse(Result<[PushUpRankingResponse], Error>)
        case consistencyRankingResponse(Result<[ConsistencyRankingResponse], Error>)
        case runningRankingResponse(Result<[RunningRankingResponse], Error>)
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
                
                return .merge(
                    .run { send in
                        await send(.consistencyRankingResponse(Result { try await rankingClient.fetchConsistency()}))
                    },
                    .run { send in
                        await send(.pushUpRankingResponse(Result { try await rankingClient.fetchPushUp()}))
                    },
                    .run { send in
                        await send(.runningRankingResponse(Result { try await rankingClient.fetchRunning()}))
                    }
                )
            case .workoutButtonTapped:
                return .none
            case let .rankingDetailButtonTapped(type):
                state.path.append(.rankingDetail(RankingDetailFeature.State(
                    type,
                    state.consistency,
                    state.pushUp,
                    state.running
                )))
                return .none
            case let .path(.element(id: _, action: .rankingDetail(.rankCellTapped(data)))):
                state.path.append(.web(PTWebFeature.State(url: "https://physical-t-7jce.vercel.app",
                                                          targetUserID: data.userID,
                                                          targetUsername: data.name)
                ))
                return .none
                
            case let .pushUpRankingResponse(.success(response)):
                state.pushUp = response
                state.pushUpTop3 = Array(response.prefix(3))
                return .none
            case let .consistencyRankingResponse(.success(response)):
                state.consistency = response
                state.consistencyTop3 = Array(response.prefix(3))
                return .none
            case .runningRankingResponse(.success(let response)):
                state.running = response
                state.runningTop3 = Array(response.prefix(3))
                return .none
            case .pushUpRankingResponse(.failure),
                    .consistencyRankingResponse(.failure),
                    .runningRankingResponse(.failure):
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
