//
//  PTWebFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/30/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PTWebFeature {
    
    @ObservableState
    struct State: Equatable {
        var url: String
        var isLoading: Bool = false
        var webViewController: PTWebViewController?
        
        init(url: String) {
            self.url = url
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case reload
        case setCookies
        case goBack
    }
    
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                state.webViewController = PTWebViewController()
                return .concatenate(
                    
                    .send(.setCookies),
                    .run { [url = state.url, webVC = state.webViewController] _ in
                        guard let url = URL(string: url) else { return }
                        await webVC?.load(with: url)
                    }
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
                
            case .reload:
                return .run { [webVC = state.webViewController] _ in
                    await webVC?.webView.reload()
                }
                
            case .goBack:
                return .run { [webVC = state.webViewController] _ in
                    guard await webVC?.webView.canGoBack ?? false
                    else { return await dismiss() }
                    await webVC?.webView.goBack()
                    return 
                    }
               
            }
        }
    }
    
}
