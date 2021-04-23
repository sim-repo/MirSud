//
//  VK_RealmService.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//

import Foundation
import RealmSwift



extension RealmService {
    
    //MARK:- public >>
    
    public static func load_VK_Token() -> (String?, String?)? {
        
        guard let realm = getInstance(.unsafe)
            else {
                return nil
        }
        let token: String? = realm.objects(RealmToken.self).first?.token
        let userId: String? = realm.objects(RealmToken.self).first?.userId
        
        return (token, userId)
    }
    
    
    
    public static func save_VK_Token(_ token: String, _ userId: String) {
        let realm = getInstance(.unsafe)
        do {
            try realm?.write {
                let obj = RealmToken()
                obj.token = token
                obj.userId = userId
                realm?.add(obj, update: .all)
            }
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
}
