//
//  Parser_CivilCaseDetail.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import SwiftyJSON
import Foundation

class Parser_CivilCaseDetail{
    
    
    
    public static func parseToken(_ val: Any) -> String {
        let json = JSON(val)
        let id = json["id"].stringValue
        return id
    }
    
    public static func parse(_ val: Any) -> CivilCaseDetail? {
        
        let json = JSON(val)
        
        let item = json["result"]
        let caseID = item["id"].stringValue // Дело Номер
        let court_site_id = item["court_site_id"].stringValue
        let court_number = item["court_number"].stringValue
        let district_name = item["district_name"].stringValue
        let judge = item["judge"].stringValue
        let type = item["type"].stringValue
        let prev_reg_id = item["prev_reg_id"].stringValue
        let description = item["description"].stringValue
        let judicial_uid = item["judicial_uid"].stringValue
        let created_date = item["created_date"].stringValue
        let accepted_date = item["accepted_date"].stringValue
        let review_date = item["review_date"].stringValue
        let name = item["name"].stringValue
        let status = item["status"].stringValue
        let url = item["url"].stringValue
        
        
        let participants = item["participants"].arrayValue
        let claimant = getClaimant(participants)  // истец
        let defendant = getDefendant(participants) // ответчик
        let (surname, fname, mName) = getFormattedDefendant(defendant)
        
        
        var histories = [CivilCaseDetail.History]()
        let arr = item["history"].arrayValue
        for (key, element) in arr.enumerated() {
            let date = element["date"].stringValue
            let time = element["time"].stringValue
            let status = element["status"].stringValue
            let publish_date = element["publish_date"].stringValue
            let publish_time = element["publish_time"].stringValue
        
            let history = CivilCaseDetail.History(id: key, date: date, time: time, status: status, publishDate: publish_date, publish_time: publish_time)
            histories.append(history)
        }
        
        var detail = CivilCaseDetail(caseID: caseID, courtSiteID: court_site_id, courtNumber: court_number, districtName: district_name, judgeName: judge, type: type, prevRegID: prev_reg_id, description: description, judicialUID: judicial_uid, createdDate: created_date, acceptedDate: accepted_date, reviewDate: review_date, name: name, status: status, url: url, claimantName: claimant, defendantFirstName: fname, defendantSurname: surname, defendantMiddleName: mName, history: histories)
        

        if let oldStatus = SPB_UserDefaultService.shared.load_CC_Detail_Status(detail.caseID) {
            if let s = CivilCase.HandleStatus.init(rawValue: oldStatus) {
                detail.handleStatus = s
            }
        }
        
        
        return detail
    }
    
    
    
    private static func getClaimant(_ participants: [JSON]) -> String {
        guard !participants.isEmpty else { return "" }
        
        let str = participants[0]["title"].stringValue
        if str == "Истец"  {
            return participants[0]["name"].stringValue
        }
        if participants.count > 1 {
            let str = participants[1]["title"].stringValue
            if str == "Истец"  {
                return participants[1]["name"].stringValue
            }
        }
        return ""
    }
    
    
    private static func getDefendant(_ participants: [JSON]) -> String {
        guard !participants.isEmpty else { return "" }

        let str = participants[0]["title"].stringValue
        if str == "Ответчик" ||  str == "Привлекаемое лицо"{
            return participants[0]["name"].stringValue
        }
        if participants.count > 1 {
            let str = participants[1]["title"].stringValue
            if str == "Ответчик" ||  str == "Привлекаемое лицо"{
                return participants[1]["name"].stringValue
            }
        }
        return ""
    }
    
    
    private static func getFormattedDefendant(_ defendant: String) -> (String, String, String) {
        var fname: String = ""
        var midName: String = ""
        var surname: String = ""
        
        let defendantArr = defendant.components(separatedBy: " ")
        
        if !defendantArr.isEmpty {
            surname = defendantArr[0]
        }
    
        if defendantArr.count > 1 {
            fname = defendantArr[1]
        }
        
        if defendantArr.count > 2 {
            midName = defendantArr[2]
        }
        return (surname, fname, midName)
    }
    
}
