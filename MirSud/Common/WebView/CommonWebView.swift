//
//  CommonWebView.swift
//  MirSud
//
//  Created by Igor Ivanov on 20.04.2021.
//

import UIKit
import WebKit
import SwiftUI

struct CommonWebview: UIViewRepresentable {
    let url: URL
    
    let navigationHelper = CommonWebviewDelegate()
    
    
    func makeUIView(context: UIViewRepresentableContext<CommonWebview>) -> WKWebView {
        let webview = WKWebView()
        webview.scrollView.isScrollEnabled = true
        webview.navigationDelegate = navigationHelper
        return webview
    }
    
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<CommonWebview>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
}



class CommonWebviewDelegate: NSObject, WKNavigationDelegate {
}
