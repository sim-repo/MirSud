//
//  RealmCasesIDs.swift
//  MirSud
//
//  Created by Igor Ivanov on 20.04.2021.
//

import Foundation

class RealmCivilCase: RealmBase {
    @objc dynamic var ccID = ""
    @objc dynamic var courtNumber: String = ""
    @objc dynamic var courtSiteID: String = ""
    @objc dynamic var districtName: String = ""
    @objc dynamic var judgeName: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var prevRegID: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var judicialUID: String = ""
    
    @objc dynamic var createdDate: String = ""
    @objc dynamic var acceptedDate: String = ""
    @objc dynamic var reviewDate: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var url: String = ""
    
    @objc dynamic var claimantName: String = ""
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var middleName: String = ""
    
    @objc dynamic var handleStatus: String = ""
}

