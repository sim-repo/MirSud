//
//  User.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//

import Foundation


import Foundation

class VK_User: Identifiable, Hashable {
    
    let id: Int //VK ID
    var firstName: String = ""
    var surname: String = ""
    var avaURL200: URL?
    var avaURLMax: URL?
    var bdate: String = ""
    var lastSeen: String = ""
    var caseID: String = ""
    
    init(_ id: Int, _ firstName: String = "", _ surname: String = "", _ avaURL200: URL? = nil, _ avaURLMax: URL? = nil, _ bdate: String = "", _ lastSeen: String = "") {
        self.id = id
        self.firstName = firstName
        self.surname = surname
        self.avaURL200 = avaURL200
        self.avaURLMax = avaURLMax
        self.bdate = bdate
        self.lastSeen = lastSeen
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: VK_User, rhs: VK_User) -> Bool {
        lhs.id == rhs.id
    }
}
