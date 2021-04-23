//
//  Defendant.swift
//  MirSud
//
//  Created by Igor Ivanov on 16.04.2021.
//

import Foundation

class Defendant: Identifiable, Hashable {
    
    enum Status: String, CaseIterable {
        case cold="холодный", warm="теплый", hot="горячий", useless="бесполезный"
    }

    var id: Int = 0 // hash code
    var lastActivityDate = Date()
    var firstName: String = ""
    var surname: String = ""
    var middleName: String = ""
    var status: Defendant.Status = .cold
    var telegramID: String = ""
    var phone: String = ""
    var email: String = ""
    
    var vkUsers: [VK_User] = []
    var civilCases: [CivilCaseDetail] = []
    
    init(id: Int = 0, lastActivityDate: Date = Date(), firstName: String = "", surname: String = "", middleName: String = "", status: Defendant.Status = .cold) {
        self.id = id
        self.lastActivityDate = lastActivityDate
        self.firstName = firstName
        self.surname = surname
        self.middleName = middleName
        self.status = status
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Defendant, rhs: Defendant) -> Bool {
        lhs.id == rhs.id
    }
}




extension Defendant {
    
    static func create(from: CivilCase) -> Defendant {
        let id = getHashCode(from: from)
        let defendant = Defendant(id: id, firstName: from.defendantFirstName, surname: from.defendantSurname, middleName: from.defendantMiddleName, status: .cold)
        return defendant
    }
    
    
    static func create(from: CivilCaseDetail) -> Defendant {
        let id = getHashCode(from: from)
        let defendant = Defendant(id: id, firstName: from.defendantFirstName, surname: from.defendantSurname, middleName: from.defendantMiddleName, status: .cold)
        return defendant
    }
    
    static func getHashCode(from: CivilCase) -> Int {
        let str = from.defendantFirstName + from.defendantMiddleName + from.defendantSurname
        return str.djb2hash
    }
    
    static func getHashCode(from: CivilCaseDetail) -> Int {
        let str = from.defendantFirstName + from.defendantMiddleName + from.defendantSurname
        return str.djb2hash
    }
}
