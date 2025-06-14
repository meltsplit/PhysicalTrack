//
//  WorkoutReadyView.swift
//  PhysicalTrack
//
//  Created by MELT on 6/9/25.
//

import SwiftUI
import ComposableArchitecture

struct WorkoutReadyView: View {
    
    var store: StoreOf<WorkoutReadyFeature>
    
    var body: some View {
        VStack {
            Text("\(store.readyLeftSeconds)")
                .font(.system(size: 80))
                .fontWeight(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.8))
        .onAppear {
            store.send(.onAppear)
        }
    }
}
