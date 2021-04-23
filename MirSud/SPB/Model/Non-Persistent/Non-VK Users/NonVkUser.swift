//
//  NonVkUsers.swift
//  MirSud
//
//  Created by Igor Ivanov on 21.04.2021.
//

import Foundation

class NonVkUser: Identifiable, Hashable {
    
    var id: Int //user hash id
    
    init(id: Int) {
        self.id = id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NonVkUser, rhs: NonVkUser) -> Bool {
        lhs.id == rhs.id
    }
}
