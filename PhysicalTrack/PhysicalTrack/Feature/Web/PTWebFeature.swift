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
        @Shared(.appStorage(.userID))
        fileprivate var userID: Int = -1
        
        @Shared(.appStorage(.accessToken))
        fileprivate var accessToken: String = ""
        
        fileprivate var targetUserID: Int?
        
        var url: URL
        var representableWebView: RepresentableWebView?
        var canGoBack: Bool = false
        
        init(url: String, targetUserID: Int? = nil) {
            self.url = URL(string: url) ?? URL(string: "http://github.com")!
            self.targetUserID = targetUserID
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
                            await representableWebView?.load(with: url)
                        }
                    )
                )
                
            case .setCookies:
                return .run { [state = state] _ in
                    let cookies = [
                        [
                            HTTPCookiePropertyKey.domain: state.url.host() ?? "",
                            HTTPCookiePropertyKey.name: "access_token",
                            HTTPCookiePropertyKey.path: "/",
                            HTTPCookiePropertyKey.value: state.accessToken,
                            HTTPCookiePropertyKey.secure: "TRUE",
                            HTTPCookiePropertyKey.expires: Date().addingTimeInterval(60 * 60 * 24)
                        ],
                        [
                            HTTPCookiePropertyKey.domain: state.url.host() ?? "",
                            HTTPCookiePropertyKey.name: "user_id",
                            HTTPCookiePropertyKey.path: "/",
                            HTTPCookiePropertyKey.value: String(state.targetUserID ?? state.userID),
                            HTTPCookiePropertyKey.secure: "TRUE",
                            HTTPCookiePropertyKey.expires: Date().addingTimeInterval(60 * 60 * 24 * 7)
                        ]
                    ].compactMap { HTTPCookie(properties: $0)}
                    await state.representableWebView?.setCookies(cookies)
                }
                
            case let .canGoBackChanged(newValue):
                state.canGoBack = newValue
                return .none
                
            case .backButtonTapped:
                return .run { [state = state] _ in
                    guard state.canGoBack else { return await dismiss() }
                    await state.representableWebView?.webView.goBack()
                    await state.representableWebView?.webView.reload()
                    return
                }
                
            }
        }
    }
    
}
