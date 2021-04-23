//
//  RealmToken.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//

import Foundation
import RealmSwift

class RealmToken: RealmBase {
    @objc dynamic var token = ""
    @objc dynamic var userId = ""
}

