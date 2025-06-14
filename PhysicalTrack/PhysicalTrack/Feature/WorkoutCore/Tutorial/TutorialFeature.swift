//
//  TutorialFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/25/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TutorialFeature {
    
    @ObservableState
    struct State: Equatable {
        var currentModel : TutorialModel
        var tutorialModels: [TutorialModel]
        var isLastModel: Bool { currentModel == tutorialModels.last }
        
        init(tutorialModels: [TutorialModel]) {
            self.tutorialModels = tutorialModels
            self.currentModel = tutorialModels[0]
        }
    }
    
    enum Action: Equatable {
        case tabChanged(TutorialModel)
        case confirmButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tabChanged(model):
                state.currentModel = model
                return .none
            case .confirmButtonTapped:
                return .run { _ in return await dismiss() }
            }
        }
    }
}
