//
//  VK_LoginNetworkService.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//


import SwiftUI
import Alamofire
import WebKit


struct VK_LoginNetworkService {
    
    @ObservedObject var vm: VK_Login_VM
    

    //MARK:- Авторизация
    
    /*
     Step 1: Проверка токена
     */
    func req_checkToken(token: String, userID: String){
        let urlPath: String = "secure.checkToken"
        
        let params: Parameters = [
            "token": token,
           // "client_id": VK_Session.clientId,
            "client_secret": VK_Session.clientSecret,
            "access_token": VK_Session.accessToken,
            "v": VK_Session.versionAPI
        ]
        
        
        let onChecked: ((Bool)->Void)? = { (checked) in
            if checked {
                vm.didCredentialsSuccess(token: token, userID: userID)
            } else {
                vm.didCredentialsFailed()
            }
        }
        
        VK_AlamofireService.shared.req_checkToken(urlPath, params, onChecked)
    }
    
    
    /*
     Step 2: Подгрузка формы авторизации
     */
    func req_Auth(webview: WKWebView) {
        VK_AlamofireService.shared.req_Auth(webview: webview)
    }
    
    
}

