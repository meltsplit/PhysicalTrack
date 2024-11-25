//
//  RepresentableWebView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/30/24.
//

import SwiftUI
import Foundation
import WebKit
import ComposableArchitecture

struct RepresentableWebView: UIViewRepresentable, Equatable {
    
    let webView: WKWebView = WKWebView()
    
    @MainActor
    func load(with url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    @MainActor
    func setCookies(_ cookies: [HTTPCookie]) async {
        for cookie in cookies {
            await webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .ptBackground
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<RepresentableWebView>) { }
}

extension RepresentableWebView {
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
