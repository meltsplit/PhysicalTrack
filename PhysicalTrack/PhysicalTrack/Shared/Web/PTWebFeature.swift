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
        @Shared(.appStorage(key: .userID)) fileprivate var userID: Int = -1
        @Shared(.appStorage(key: .username)) fileprivate var username: String = "회원"
        @Shared(.appStorage(key: .accessToken)) fileprivate var accessToken: String = ""
        
        fileprivate var targetUserID: Int?
        fileprivate var targetUsername: String? = "회원"
        
        var url: URL
        var representableWebView: RepresentableWebView?
        var canGoBack: Bool = false
        
        init(
            url: String,
            targetUserID: Int? = nil,
            targetUsername: String? = nil
        ) {
            self.url = URL(string: url) ?? URL(string: "http://github.com")!
            self.targetUserID = targetUserID
            self.targetUsername = targetUsername
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case makeWebView(RepresentableWebView)
        case setCookies
        case backButtonTapped
        case canGoBackChanged(Bool)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                guard let webView = state.representableWebView else {
                    return .run { send in
                        let webView = await RepresentableWebView()
                        await send(.makeWebView(webView))
                    }
                }
                
                return .merge(
                    .run { @MainActor send in
                        for await canGoBack in webView.webView.publisher(for: \.canGoBack).values {
                            print(canGoBack)
                            send(.canGoBackChanged(canGoBack))
                        }
                    },
                    .concatenate(
                        .send(.setCookies),
                        .run { [url = state.url, webView] _ in
                            await webView.load(with: url)
                        }
                    )
                )
            case .makeWebView(let webView):
                state.representableWebView = webView
                return .send(.onAppear)
                
            case .setCookies:
                return .run { [state] _ in
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
                        ],
                        [
                            HTTPCookiePropertyKey.domain: state.url.host() ?? "",
                            HTTPCookiePropertyKey.name: "user_name",
                            HTTPCookiePropertyKey.path: "/",
                            HTTPCookiePropertyKey.value: state.targetUsername ?? state.username,
                            HTTPCookiePropertyKey.secure: "TRUE",
                            HTTPCookiePropertyKey.expires: Date().addingTimeInterval(60 * 60 * 24 * 7)
                        ]
                    ].compactMap { HTTPCookie(properties: $0) }
                    await state.representableWebView?.setCookies(cookies)
                }
                
            case let .canGoBackChanged(newValue):
                state.canGoBack = newValue
                return .none
                
            case .backButtonTapped:
                return .run { [state] _ in
                    guard state.canGoBack else { return await dismiss() }
                    await state.representableWebView?.webView.goBack()
                    await state.representableWebView?.webView.reload()
                    return
                }
                
            }
        }
    }
    
}
