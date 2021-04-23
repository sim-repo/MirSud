//
//  Parser_VK_Users.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//


import SwiftyJSON
import Foundation

class Parser_VK_UserList{
     
    public static func parse(_ val: Any) -> [VK_User] {
        let json = JSON(val)
        var res: [VK_User] = []
        let items = json["response"]["items"].arrayValue
        for item in items {
            
            let vkID = item["id"].intValue
            let firstName = item["first_name"].stringValue
            let surname = item["last_name"].stringValue
            let avaURL200 = URL(string: item["photo_200"].stringValue)
            let avaURLMax = URL(string: item["photo_max"].stringValue)
            let lastSeen = item["last_seen"]["time"].stringValue
            let bdate = item["bdate"].stringValue
            
            let vkUser = VK_User(vkID, firstName, surname, avaURL200, avaURLMax, bdate, lastSeen)
            res.append(vkUser)
        }
        return res
    }
}
