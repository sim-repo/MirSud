//
//  VK_Login.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//

import SwiftUI
import WebKit
import MessageUI

struct VK_Login_View: View {
    
    @EnvironmentObject var vm: VK_Login_VM
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = true
    
    
    var body: some View {
        NavigationView {
            if vm.showVkFormAuthentication {
                Webview(url: URL(string: "https://www.yandex.ru")!)
                    .frame(minWidth: 320, idealWidth: 440, maxWidth: 440, minHeight: 667, idealHeight: 812, maxHeight: 812, alignment: .top)
            } else {
                VStack {
                    Text("VK авторизация: OK.")
                    MailView(isShowing: $isShowingMailView, result: self.$result)
                }
            }
        }
        .onAppear{
            vm.viewDidAppear()
        }
    }
    
    func makeCanSendMail() -> some View {
        if !MFMailComposeViewController.canSendMail() {
            return Text("Сurrent device is configured to send email.")
        }
        return Text("Mail services are unavailable.")
    }
}


struct Webview: UIViewRepresentable {
    let url: URL
    
    @EnvironmentObject var vm: VK_Login_VM
    
    let navigationHelper = VK_WebViewDelegate()
    
    
    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        navigationHelper.setup(vm)
        let webview = WKWebView()
        webview.scrollView.isScrollEnabled = true
        webview.navigationDelegate = navigationHelper
        vm.didWebViewOpened(webview: webview)
        return webview
    }
    
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<Webview>) {
//        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
//        webview.load(request)
    }
}



class VK_WebViewDelegate: NSObject, WKNavigationDelegate {
    
    var vm: VK_Login_VM?
    
    func setup(_ vm: VK_Login_VM) {
        self.vm = vm
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        guard let token = params["access_token"],
              let userId = params["user_id"]
        else {
            decisionHandler(.cancel)
            vm?.didVKAuth(token: "", userID: "")
            return
        }
        decisionHandler(.cancel)
        vm?.didVKAuth(token: token, userID: "\(userId)")
    }
}
