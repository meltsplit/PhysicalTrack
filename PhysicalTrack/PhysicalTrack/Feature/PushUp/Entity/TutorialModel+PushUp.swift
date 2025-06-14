//
//  Tutorial+PushUp.swift
//  PhysicalTrack
//
//  Created by MELT on 6/9/25.
//

import Foundation

extension TutorialModel {
    struct PushUp {
        static let first = TutorialModel(
            title: "기기를 평평한 바닥에 놓아주세요.",
            description: "카메라를 코와 일직선에 맞추세요.",
            image: .tutorial1
        )
        
        static let second = TutorialModel(
            title: "팔굽혀펴기를 시작하세요.",
            description: "기기와 2cm 이내의 간격으로 접근하세요.",
            image: .tutorial2
        )
        
        static let third = TutorialModel(
            title: "횟수가 자동으로 측정됩니다.",
            description: "근접 센서가 자동으로 횟수를 측정해줍니다.",
            image: .tutorial3
        )
    }
}

extension Array where Element == TutorialModel {
    static let pushUp: [Element] = [
        .PushUp.first,
        .PushUp.second,
        .PushUp.third
    ]
}
