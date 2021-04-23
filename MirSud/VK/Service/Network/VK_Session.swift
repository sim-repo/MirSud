//
//  VK_Session.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//

import Foundation


class VK_Session {
    static let shared = VK_Session()
    
    private init(){}
    
    var token = ""
    var userId = ""

    func set(_ token: String, _ userId: String) {
        self.token = token
        self.userId = userId
    }
    
    static var versionAPI = "5.130"
    static var baseURL = "https://api.vk.com/method/"
    static var clientId = "7829939"
    static var clientSecret = "lNu3DntEvFqI8NALfiKD"
    static var accessToken = "cb98f825cb98f825cb98f8250ecbef8196ccb98cb98f825abe5e2bfc7815474f8540882"
}
