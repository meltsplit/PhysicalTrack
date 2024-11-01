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
        var representableWebView: RepresentableWebView?
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
                if state.representableWebView == nil {
                    state.representableWebView = RepresentableWebView()
                }
                
                return .merge(
                    .publisher {
                        state.representableWebView!.webView.publisher(for: \.canGoBack)
                            .map { .canGoBackChanged($0) }
                    },
                    .concatenate(
                        .send(.setCookies),
                        .run { [url = state.url, representableWebView = state.representableWebView] _ in
                            guard let url = URL(string: url) else { return }
                            await representableWebView?.load(with: url)
                        }
                    )
                    
                    
                )
                
            case .setCookies:
                return .run { [representableWebView = state.representableWebView] _ in
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
                    await representableWebView?.setCookies(cookies)
                }
                
            case let .canGoBackChanged(newValue):
                state.canGoBack = newValue
                return .none
                
            case .backButtonTapped:
                return .run { [representableWebView = state.representableWebView, canGoBack = state.canGoBack] _ in
                    guard canGoBack else { return await dismiss() }
                    await representableWebView?.webView.goBack()
                    await representableWebView?.webView.reload()
                    return
                }
                
            }
        }
    }
    
}
