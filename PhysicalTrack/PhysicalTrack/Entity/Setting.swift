//
//  Setting.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import Foundation

struct SettingType: Hashable {
    var title: String
    var systemImage: String?
}

extension SettingType {
    static let 사용법: Self = .init(title: "사용법", systemImage: "questionmark.circle")
    static let 문의하기: Self = .init(title: "문의하기", systemImage: "envelope")
    static let 앱공유하기: Self = .init(title: "앱 공유하기", systemImage: "square.and.arrow.up")
    static let 개발자응원하기: Self = .init(title: "개발자 응원하기", systemImage: "heart")
}
