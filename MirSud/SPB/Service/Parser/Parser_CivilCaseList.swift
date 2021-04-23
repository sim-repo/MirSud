//
//  SPB_Parser.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import SwiftyJSON
import Foundation

class Parser_CivilCaseList{
     
    
    public static func parseToken(_ val: Any) -> String {
        let json = JSON(val)
        let id = json["id"].stringValue
        return id
    }
    
    
    public static func parse(_ val: Any) -> [CivilCase] {
        
            let json = JSON(val)
        
            var res: [CivilCase] = []
        
            let items = json["result"]["data"].arrayValue
            for item in items {
                let id = item["id"].stringValue // Дело Номер
                let sDate = item["date"].stringValue
                guard let date = sDate.toDate() else { fatalError() }
                let article = item["article"].stringValue
                
                let offenders = item["offenders"].stringValue
                let offendersArr = offenders.components(separatedBy: " ")
                
                var fname: String = ""
                var midName: String = ""
                var surname: String = ""
                
                if !offendersArr.isEmpty {
                    surname = offendersArr[0]
                }
                if offendersArr.count > 1 {
                    fname = offendersArr[1]
                }
                
                if offendersArr.count > 2 {
                    midName = offendersArr[2]
                }
                
                
                let court_site_id = item["court_site_id"].stringValue
                let court_number = item["court_number"].stringValue
                let url = item["url"].stringValue
                let status = item["status"].stringValue
                
                let third_parties = item["third_parties"].stringValue
                let claimants = item["claimants"].stringValue // истец
                let defendants = item["defendants"].stringValue // ответчик
                let respondents = item["respondents"].stringValue
                
                let rec = CivilCase(id: id.hashValue, caseID: id, article: article, courtNumber: court_number, date: date, status: status, plaintiffName: defendants, defendantFirstName: fname, defendantSurname: surname, defendantMiddleName: midName, claimants: claimants, respondents: respondents, thirdParties: third_parties, url: url, courtSiteId: court_site_id)

                if let oldStatus = SPB_UserDefaultService.shared.load_CC_Status(rec.caseID) {
                    if let s = CivilCase.HandleStatus.init(rawValue: oldStatus) {
                        rec.handleStatus = s
                    }
                }
                
                res.append(rec)
                
            }
            
            return res
        }
}
