//
//  CivilCaseDetail.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import Foundation

class CivilCaseDetail: Identifiable, Hashable {
    
    var id: Int
    var caseID: String = "" // Дело Номер
    
    //Основные сведения:
    var courtSiteID: String = ""
    var courtNumber: String = "" // Участок
    var districtName: String = "" //Район
    
    var judgeName: String = "" //Судья
    var type: String = ""
    var prevRegID: String = ""

    var description: String = "" //Сущность Спора
    
    var judicialUID: String = "" // Уникальный ИД
    
    var createdDate: String = "" //Дата поступления
    var acceptedDate: String = "" //Дата принятия к производству
    var reviewDate: String = ""
    var name: String = ""
    var status: String = ""
    var url: String = ""
    
    //Сведения о сторонах по делу:
    var claimantName: String = "" //Истец
    var defendantFirstName: String = "" //Ответчик: Имя
    var defendantSurname: String = "" //Фамилия
    var defendantMiddleName: String = "" //Отчество
    
    var history: [History] = []
    
    var handleStatus: CivilCase.HandleStatus = .new
    
    
    struct History: Identifiable {
        var id: Int
        let date: String
        let time: String
        let status: String
        let publishDate: String
        let publish_time: String
    }
    

    
    init(caseID: String = "", courtSiteID: String = "", courtNumber: String = "", districtName: String = "", judgeName: String = "", type: String = "", prevRegID: String = "", description: String = "", judicialUID: String = "", createdDate: String = "", acceptedDate: String = "", reviewDate: String = "", name: String = "", status: String = "", url: String = "", claimantName: String = "", defendantFirstName: String = "", defendantSurname: String = "", defendantMiddleName: String = "", history: [CivilCaseDetail.History] = []) {
        
        self.id = caseID.hashValue
        self.caseID = caseID
        self.courtSiteID = courtSiteID
        self.courtNumber = courtNumber
        self.districtName = districtName
        self.judgeName = judgeName
        self.type = type
        self.prevRegID = prevRegID
        self.description = description
        self.judicialUID = judicialUID
        self.createdDate = createdDate
        self.acceptedDate = acceptedDate
        self.reviewDate = reviewDate
        self.name = name
        self.status = status
        self.url = url
        self.claimantName = claimantName
        self.defendantFirstName = defendantFirstName
        self.defendantSurname = defendantSurname
        self.defendantMiddleName = defendantMiddleName
        self.history = history
    }
    
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CivilCaseDetail, rhs: CivilCaseDetail) -> Bool {
        lhs.id == rhs.id
    }

    
}
