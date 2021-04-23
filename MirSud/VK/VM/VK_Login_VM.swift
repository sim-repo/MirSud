//
//  VK_Login_VM.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//

import Combine
import SwiftUI
import WebKit

class VK_Login_VM: ObservableObject {
    
    @Published var model: VK_Login = VK_Login()
    
    @Published var showVkFormAuthentication: Bool = false
    
    @Published var users: [VK_User] = []
    
    
    var networkService: VK_LoginNetworkService?
    
    init(){
        setupNetwork()
    }
    
    func setupNetwork(){
        networkService = VK_LoginNetworkService(vm: self)
    }
}



// MARK: - authentication flow
extension VK_Login_VM {
    
    /*
     1. при открытии View из DB берется UserID и Token, если есть
     2. оба проверяются на валидность на сервере VK tryCheckCredentials(..)
     3. если успешно, то придет event на didCredentialsSuccess(..)
     4. если не успешно, то придет event на - didCredentialsFailed(..)
     5. при п4 - требуется повторная авторизация, после которой придет event на didVKAuth(..)
     */
    
    public func viewDidAppear(){
        if !tryCheckCredentials() {
            showVkFormAuthentication = true
        }
    }
    
    
    private func tryCheckCredentials() -> Bool {
        if let (t,u) = RealmService.load_VK_Token(),
           let token = t,
           let userID = u {
            networkService?.req_checkToken(token: token, userID: userID)
            return true
        }
        return false
    }
    
    
    func didCredentialsSuccess(token: String, userID: String){
        authSucceeded(token, userID)
    }
    
    
    func didCredentialsFailed(){
        showVkFormAuthentication = true
    }
    
    
    func didWebViewOpened(webview: WKWebView){
        networkService?.req_Auth(webview: webview)
    }
    
    
    func didVKAuth(token: String, userID: String){
        RealmService.save_VK_Token(token, userID)
        authSucceeded(token, userID)
    }
    
    private func authSucceeded(_ token: String, _ userID: String){
        VK_Session.shared.token = token
        VK_Session.shared.userId = userID
        showVkFormAuthentication = false
        tryUserSearch()
    }
}


// MARK: - user.search flow
extension VK_Login_VM {
    
    private func tryUserSearch() {
    //    networkService?.req_UsersSearch(search: "Иванов")
    }
}
