//
//  CivilCase.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import Foundation

class CivilCase: Identifiable, Hashable {
    
    enum HandleStatus: String, CaseIterable {
        case new="новый", in_progress="в процессе", canceled="отмененный", done="выполнен"
    }
    
    var id: Int //hash id
    var caseID: String = "" // Дело Номер
    var article: String = "" //Статья КоАП РФ
    var courtNumber: String = "" // Участок
    var date: Date = Date()
    var status: String = ""
    
    
    var plaintiffName: String = "" //Истец
    var defendantFirstName: String = "" //Ответчик: Имя
    var defendantSurname: String = "" //Фамилия
    var defendantMiddleName: String = "" //Отчество
    
    var claimants: String = ""
    var respondents: String = ""
    var thirdParties: String = ""
    
    var url: String = ""
    var courtSiteId: String = ""
    
    var handleStatus: HandleStatus = .new
    
    var vkIDs: [Int] = []
    
    internal init(id: Int = 0, caseID: String = "", article: String = "", courtNumber: String = "", date: Date = Date(), status: String = "", plaintiffName: String = "", defendantFirstName: String = "", defendantSurname: String = "", defendantMiddleName: String = "", claimants: String = "", respondents: String = "", thirdParties: String = "", url: String = "", courtSiteId: String = "", handleStatus: CivilCase.HandleStatus = .new) {
        self.id = id
        self.caseID = caseID
        self.article = article
        self.courtNumber = courtNumber
        self.date = date
        self.status = status
        self.plaintiffName = plaintiffName
        self.defendantFirstName = defendantFirstName
        self.defendantSurname = defendantSurname
        self.defendantMiddleName = defendantMiddleName
        self.claimants = claimants
        self.respondents = respondents
        self.thirdParties = thirdParties
        self.url = url
        self.courtSiteId = courtSiteId
        self.handleStatus = handleStatus
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CivilCase, rhs: CivilCase) -> Bool {
        lhs.id == rhs.id
    }

}
