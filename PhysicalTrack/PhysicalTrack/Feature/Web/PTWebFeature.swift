//
//  PTWebFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/30/24.
//

import Foundation
import ComposableArchitecture
import Combine

@Reducer
struct PTWebFeature {

    @ObservableState
    struct State: Equatable {
        var url: String
        var webViewController: RepresentableWebView?
        var canGoBack: Bool = false
        
        init(url: String) {
            self.url = url
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case setCookies
        case backButtonTapped
        case canGoBackChanged(Bool)
    }

    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                if state.webViewController == nil {
                    state.webViewController = RepresentableWebView()
                }
      
                return .merge(
                    .publisher {
                        state.webViewController!.webView.publisher(for: \.canGoBack)
                            .map { .canGoBackChanged($0) }
                    },
                    .concatenate(
                        .send(.setCookies),
                        .run { [url = state.url, webVC = state.webViewController] _ in
                            guard let url = URL(string: url) else { return }
                            await webVC?.load(with: url)
                        }
                    )
                   
                    
                )
                
            case .setCookies:
                return .run { [webVC = state.webViewController] _ in
                    let cookies = [
                        [
                            HTTPCookiePropertyKey.domain: "physical-t-p3n2.vercel.app",
                            HTTPCookiePropertyKey.name: "access_token",
                            HTTPCookiePropertyKey.path: "/",
                            HTTPCookiePropertyKey.value: "stub_access_token",
                            HTTPCookiePropertyKey.secure: "TRUE",
                            HTTPCookiePropertyKey.expires: Date().addingTimeInterval(60 * 60 * 24)
                        ],
                        [
                            HTTPCookiePropertyKey.domain: "physical-t-p3n2.vercel.app",
                            HTTPCookiePropertyKey.name: "user_id",
                            HTTPCookiePropertyKey.path: "/",
                            HTTPCookiePropertyKey.value: "stub_user_id",
                            HTTPCookiePropertyKey.secure: "TRUE",
                            HTTPCookiePropertyKey.expires: Date().addingTimeInterval(60 * 60 * 24 * 7)
                        ]
                    ].compactMap { HTTPCookie(properties: $0)}
                    await webVC?.setCookies(cookies)
                }

            case let .canGoBackChanged(newValue):
                state.canGoBack = newValue
                return .none

            case .backButtonTapped:
                return .run { [webVC = state.webViewController, canGoBack = state.canGoBack] _ in
                    guard canGoBack else { return await dismiss() }
                    await webVC?.webView.goBack()
                    await webVC?.webView.reload()
                    return
                    }
               
            }
        }
    }
    
}
