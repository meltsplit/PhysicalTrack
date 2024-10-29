//
//  PTWebView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/30/24.
//

import SwiftUI
import WebKit

struct SMWebView: UIViewRepresentable {
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            print("유효하지 않은 URL")
            return WKWebView()
        }
        
        let webView = WKWebView()
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.isOpaque = false
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<SMWebView>) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
}
