//
//  SPB_RealmService.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//

import Foundation
import RealmSwift



extension RealmService { 
    
    //MARK:- public >>
    public static func loadDefendants(filter: String? = nil) -> [Defendant]? {
        
        var results: Results<RealmDefendant>
        guard let realm = getInstance(.unsafe) else { return nil }
        
        if let _filter = filter {
            results = realm.objects(RealmDefendant.self).filter(_filter)
        } else {
            results = realm.objects(RealmDefendant.self)
        }
        let defendants = realmToDefendant(results: results)
        return defendants
    }
    
    
    public static func saveDefendants(defendants: [Defendant], update: Bool){
        var objects: [Object] = []
        for defendant in defendants {
            let obj = defendantToRealm(defendant)
            objects.append(obj)
        }
        save(items: objects, update: update)
    }
    
    
    public static func deleteDefendant(id: Int? = nil) {
        delete(confEnum: .unsafe, clazz: RealmDefendant.self, id: id)
    }
    
    
    
    public static func loadNonVKUsers() -> [NonVkUser]? {
        var results: Results<RealmNonVKUser>
        guard let realm = getInstance(.unsafe) else { return nil }
        
        results = realm.objects(RealmNonVKUser.self)
        let nonVKUsers = realmToNonVKUsers(results: results)
        return nonVKUsers
    }
    
    
    public static func saveNonVKUsers(nonVKUsers: [NonVkUser], update: Bool){
        var objects: [Object] = []
        for user in nonVKUsers {
            let obj = nonVKUsersToRealm(user)
            objects.append(obj)
        }
        save(items: objects, update: update)
    }
    
    
    //MARK:- model -> realm

    private static func defendantToRealm(_ defendant: Defendant) -> RealmDefendant {
        let realmDefendant = RealmDefendant()
        realmDefendant.id = defendant.id
        realmDefendant.firstName = defendant.firstName
        realmDefendant.surname = defendant.surname
        realmDefendant.middleName = defendant.middleName
        realmDefendant.status = defendant.status.rawValue
        realmDefendant.lastActivityDate = defendant.lastActivityDate.toString()
        
        let arr = List<RealmVkUser>()
        for vkUser in defendant.vkUsers {
            let r = RealmVkUser()
            r.id = "\(vkUser.id)".djb2hash
            r.vkID = String(vkUser.id)
            r.firstName = vkUser.firstName
            r.surname = vkUser.surname
            r.lastSeen = vkUser.lastSeen
            r.bdate = vkUser.bdate
            r.avaURL200 = vkUser.avaURL200?.absoluteString ?? ""
            r.avaURLMax = vkUser.avaURLMax?.absoluteString ?? ""
            arr.append(r)
        }
        realmDefendant.vkUsers = arr
        
        
        let arr2 = List<RealmCivilCase>()
        for cc in defendant.civilCases{
            let r = RealmCivilCase()
            r.id = cc.caseID.djb2hash
            r.ccID = cc.caseID
            r.firstName = cc.defendantFirstName
            r.surname = cc.defendantSurname
            r.middleName = cc.defendantMiddleName
            r.courtNumber = cc.courtNumber
            r.courtSiteID = cc.courtSiteID
            r.districtName = cc.districtName
            r.judgeName = cc.judgeName
            r.type = cc.type
            r.prevRegID = cc.prevRegID
            r.desc = cc.description
            r.judicialUID = cc.judicialUID
            
            r.createdDate = cc.createdDate
            r.acceptedDate = cc.acceptedDate
            r.reviewDate = cc.reviewDate
            r.name = cc.name
            r.status = cc.status
            r.url = cc.url
            r.claimantName = cc.claimantName
            r.handleStatus = cc.handleStatus.rawValue
            arr2.append(r)
        }
        realmDefendant.cases = arr2
        return realmDefendant
    }
    
    
    private static func nonVKUsersToRealm(_ nonVKUser: NonVkUser) -> RealmNonVKUser {
        let r = RealmNonVKUser()
        r.id = nonVKUser.id
        return r
    }
    
    
    
    //MARK:- realm -> model
    
    private static func realmToDefendant(results: Results<RealmDefendant>) -> [Defendant] {
        var defendants = [Defendant]()
        
        for result in results {
            let defendant = Defendant(id: Int(result.id))
            defendant.firstName = result.firstName
            defendant.surname = result.surname
            defendant.middleName = result.middleName
            defendant.status = Defendant.Status.init(rawValue: result.status)!
            if let date = result.lastActivityDate.toDate() {
                defendant.lastActivityDate =  date
            }
            
            defendant.vkUsers = []
            for vk in result.vkUsers {
                if let id = Int(vk.vkID) {
                    let fname = vk.firstName
                    let surname = vk.surname
                    let bdate = vk.bdate
                    let lastSeen = vk.lastSeen
                    let avaURL200 = URL(string: vk.avaURL200)
                    let avaURLMax = URL(string: vk.avaURLMax)
                    
                    let vkUser = VK_User(id, fname, surname, avaURL200, avaURLMax, bdate, lastSeen)
                    defendant.vkUsers.append(vkUser)
                }
            }
            
            
            defendant.civilCases = []
            for cc in result.cases {
                let caseID = cc.ccID
                let fname = cc.firstName
                let surname = cc.surname
                let middleName = cc.middleName
                let courtNumber = cc.courtNumber
                let courtSiteID = cc.courtSiteID
                let districtName = cc.districtName
                let judgeName = cc.judgeName
                let type = cc.type
                let prevRegID = cc.prevRegID
                let desc = cc.desc
                let judicialUID = cc.judicialUID
                
                let createdDate = cc.createdDate
                let acceptedDate = cc.acceptedDate
                let reviewDate = cc.reviewDate
                let name = cc.name
                let status = cc.status
                let url = cc.url
                let claimantName = cc.claimantName
                
                
                let detail = CivilCaseDetail(caseID: caseID, courtSiteID: courtSiteID, courtNumber: courtNumber, districtName: districtName, judgeName: judgeName, type: type, prevRegID: prevRegID, description: desc, judicialUID: judicialUID, createdDate: createdDate, acceptedDate: acceptedDate, reviewDate: reviewDate, name: name, status: status, url: url, claimantName: claimantName, defendantFirstName: fname, defendantSurname: surname, defendantMiddleName: middleName, history: [])
                detail.handleStatus = CivilCase.HandleStatus.init(rawValue:  cc.handleStatus)!
                defendant.civilCases.append(detail)
            }
            
            defendants.append(defendant)
        }
        return defendants
    }
    
    
    
    private static func realmToNonVKUsers(results: Results<RealmNonVKUser>) -> [NonVkUser] {
        var res = [NonVkUser]()
        
        for result in results {
            let user = NonVkUser(id: Int(result.id))
            res.append(user)
        }
        
        return res
    }

}
