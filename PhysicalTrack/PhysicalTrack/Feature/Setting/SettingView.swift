//
//  SettingView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    let store : StoreOf<SettingFeature>
    
    var body: some View {
        Text("Setting")
    }
}

#Preview {
    SettingView(
        store: .init(initialState: SettingFeature.State()) {
            SettingFeature()
        }
    )
}
