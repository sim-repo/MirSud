//
//  VK_Login.swift
//  MirSud
//
//  Created by Igor Ivanov on 19.04.2021.
//

import Foundation

class VK_Login: Identifiable, Hashable {
 
    var id: Int = 0

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: VK_Login, rhs: VK_Login) -> Bool {
        lhs.id == rhs.id
    }
}

