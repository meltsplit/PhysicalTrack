//
//  StatisticsView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct StatisticsView: View {
    let store : StoreOf<StatisticsFeature>
    let webView = SMWebView(url: "https://physical-t-7jce.vercel.app")
    
    var body: some View {
        VStack {
            HStack {
                Button("쿠키 확인") {
                    webView.printCookie()
                }
            }
            
            webView
            
        }
            
    }
}

#Preview {
    StatisticsView(
        store: .init(initialState: StatisticsFeature.State()) {
            StatisticsFeature()
        }
    )
}
