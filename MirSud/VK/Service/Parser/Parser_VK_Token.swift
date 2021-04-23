//
//  Parser_VK_Token.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//

import SwiftyJSON


class Parser_VK_Token {
    typealias success = String
    typealias error = String
    
    public static func parse(_ json: JSON) -> (success, error){
        let errorMsg = json["error"]["error_msg"].stringValue
        if errorMsg != ""  {
            return ("",errorMsg)
        }
        return ("success","")
    }
}


