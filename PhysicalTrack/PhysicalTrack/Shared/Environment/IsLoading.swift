//
//  IsLoadingKey.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/22/25.
//

import SwiftUI

struct IsLoadingEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isLoading: Bool {
        get { self[IsLoadingEnvironmentKey.self] }
        set { self[IsLoadingEnvironmentKey.self] = newValue }
    }
}
