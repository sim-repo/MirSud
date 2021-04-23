//
//  RealmVkIDs.swift
//  MirSud
//
//  Created by Igor Ivanov on 20.04.2021.
//

import Foundation

class RealmVkUser: RealmBase {
    @objc dynamic var vkID = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var avaURL200: String = ""
    @objc dynamic var avaURLMax: String = ""
    @objc dynamic var bdate: String = ""
    @objc dynamic var lastSeen: String = ""
}
