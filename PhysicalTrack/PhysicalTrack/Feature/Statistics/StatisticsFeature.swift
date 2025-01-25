//
//  StatisticsFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StatisticsFeature {
    
    @ObservableState
    struct State {
        private var _userID: Int
        var web: PTWebFeature.State?
        
        init(_ userID: Int = 1) {
            self._userID = userID
            self.web = .init(url: "https://physical-t-7jce.vercel.app")
        }
        
    }
    
    enum Action {
        case web(PTWebFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .web:
                return .none
            }
        }
        .ifLet(\.web, action: \.web) {
            PTWebFeature()
        }
    }
}
