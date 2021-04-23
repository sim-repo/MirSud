//
//  SPB_AlamofireService.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class SPB_AlamofireService {
    
    public static let sharedManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        config.timeoutIntervalForRequest = 40
        config.timeoutIntervalForResource = 40
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
    
    
    public static func req_CivilCaseToken(_ params: Parameters,
                                         _ onSuccess: @escaping ((String)->Void),
                                         _ onError: @escaping ((NSError) -> Void)) {
        
        let path = "https://www.mirsud.spb.ru/cases/api/search"
        
        sharedManager.request(path, method: .get, parameters: params).responseJSON{ response in
            switch response.result {
                case .success(let json):
                    let token = Parser_CivilCaseList.parseToken(json)
                    onSuccess(token)
                case .failure(let err):
                    let error = err as NSError
                    onError(error)
            }
        }
    }
    
    
    
    
    public static func req_CivilCaseList(_ params: Parameters,
                                         _ onSuccess: @escaping (([CivilCase])->Void),
                                         _ onError: @escaping ((NSError) -> Void)) {
        
        let path = "https://www.mirsud.spb.ru/cases/api/results"
        
        sharedManager.request(path, method: .get, parameters: params).responseJSON{ response in
            switch response.result {
            case .success(let json):
                let list = Parser_CivilCaseList.parse(json)
                onSuccess(list)
            case .failure(let err):
                let error = err as NSError
                onError(error)
            }
        }
    }
    
    
    
    public static func req_CivilCaseDetailToken(_ params: Parameters,
                                         _ onSuccess: @escaping ((String)->Void),
                                         _ onError: @escaping ((NSError) -> Void)) {
        
        let path = "https://mirsud.spb.ru/cases/api/detail"
        
        sharedManager.request(path, method: .get, parameters: params).responseJSON{ response in
            switch response.result {
            case .success(let json):

                let token = Parser_CivilCaseDetail.parseToken(json)
                onSuccess(token)

            case .failure(let err):
                let error = err as NSError
                onError(error)
            }
        }
    }
    
    
    
    public static func req_CivilCaseDetail(_ params: Parameters,
                                         _ onSuccess: @escaping ((CivilCaseDetail)->Void),
                                         _ onError: @escaping ((NSError) -> Void)) {
        
        let path = "https://www.mirsud.spb.ru/cases/api/results"
        
        
        sharedManager.request(path, method: .get, parameters: params).responseJSON{ response in
            switch response.result {
            case .success(let json):
                
                if let detail = Parser_CivilCaseDetail.parse(json) {
                    onSuccess(detail)
                }

            case .failure(let err):
                let error = err as NSError
                onError(error)
            }
        }
    }
    
    
    
    
    //MARK:- Поиск пользователей
    /*
     Step 1: Подгрузка формы авторизации
     */
    
    public static func req_UserSearch(  _ urlPath: String,
                                         _ params: Parameters,
                                         _ onSuccess: @escaping (([VK_User])->Void),
                                         _ onError: @escaping ((NSError) -> Void)) {
        
        sharedManager.request(VK_Session.baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
            switch response.result {
            case .success(let json):
                let list = Parser_VK_UserList.parse(json)
                onSuccess(list)
            case .failure(let err):
                let error = err as NSError
                onError(error)
            }
        }
    }
    
}
