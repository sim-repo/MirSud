//
//  VK_AlamofireService.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import WebKit

class VK_AlamofireService {
    
    static let shared = VK_AlamofireService()
    private init() {}
    
    
    public let sharedManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        config.timeoutIntervalForRequest = 40
        config.timeoutIntervalForResource = 40
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
    
    
    
    /*
     Step 1: Проверка токена
     */
    public func req_checkToken(_ urlPath: String,
                               _ params: Parameters,
                               _ onChecked: ((Bool)->Void)?) {
        
        sharedManager.request(VK_Session.baseURL + urlPath, method: .post, parameters: params).responseJSON{ response in
            switch response.result {
                case .success(let val):
                    let json = JSON(val)
                    let (success,_) = Parser_VK_Token.parse(json)
                    if success != "" {
                        onChecked?(true)
                        return
                    } else {
                        onChecked?(false)
                    }
                    
                case .failure(let err):
                    onChecked?(false)
                    let error = err as NSError
                    print(error)
            }
        }
    }
    
    
    /*
     Step 2: Подгрузка формы авторизации
     */
    public func req_Auth(webview: WKWebView) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: VK_Session.clientId),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "email,status"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.87")
        ]
        let request = URLRequest(url: urlComponents.url!)
        webview.load(request)
    }
    
    

}
