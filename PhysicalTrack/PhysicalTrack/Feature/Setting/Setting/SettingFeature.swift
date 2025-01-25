//
//  SettingFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SettingFeature {
    
    @ObservableState
    struct State {
        @Shared(.appStorage(key: .username)) var name = "회원"
        let list: [SettingType] = [.사용법, .문의하기]
        var path = StackState<Path.State>()
        @Presents var tutorial: TutorialFeature.State?
        @Presents var web: PTWebFeature.State?
    }
    
    enum Action {
        case userInfoTapped
        case listTapped(SettingType)
        case path(StackActionOf<Path>)
        case tutorial(PresentationAction<TutorialFeature.Action>)
        case web(PresentationAction<PTWebFeature.Action>)
    }
    
    @Reducer
    enum Path {
        case userInfo(UserInfoFeature)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .userInfoTapped:
                state.path.append(.userInfo(.init()))
                return .none
            case let .listTapped(type):
                switch type {
                case .문의하기:
                    state.web = PTWebFeature.State(url: "https://forms.gle/bQZDot2BPxFGjoFi6")
                    return .none
                case .사용법:
                    state.tutorial = TutorialFeature.State()
                    return .none
                default:
                    return .none
                }
            case .path:
                return .none
            case .tutorial:
                return .none
            case .web:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$tutorial, action: \.tutorial) {
            TutorialFeature()
        }
        .ifLet(\.$web, action: \.web) {
            PTWebFeature()
        }
    }
}
