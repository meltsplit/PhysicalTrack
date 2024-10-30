//
//  PTWebView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/30/24.
//

import SwiftUI
import Foundation
import WebKit

struct SMWebView: UIViewRepresentable {
    
    var url: String
    let webView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            print("유효하지 않은 URL")
            return webView
        }
        
        
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.isOpaque = false
        
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
        ]
        
        // 모든 쿠키 설정 후 페이지를 로드하기 위해 DispatchGroup 사용
        let dispatchGroup = DispatchGroup()
        
        for properties in cookies {
            if let cookie = HTTPCookie(properties: properties) {
                dispatchGroup.enter()
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            webView.load(URLRequest(url: url))
        }
        
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<SMWebView>) {
        guard let url = URL(string: url) else { return }
        webView.load(URLRequest(url: url))
    }
}

extension SMWebView {
    func printCookie() {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            cookies.forEach { cookie in
                print("""
                        -------------------
                        Cookie name: \(cookie.name)
                        Value: \(cookie.value)
                        Domain: \(cookie.domain)
                        Path: \(cookie.path)
                        Expires: \(String(describing: cookie.expiresDate))
                        Is Secure: \(cookie.isSecure)
                        """)
            }
        }
    }
}
