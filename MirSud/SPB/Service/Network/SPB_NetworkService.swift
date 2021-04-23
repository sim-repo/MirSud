//
//  SPB_Network.swift
//  MirSud
//
//  Created by Igor Ivanov on 16.04.2021.
//

import SwiftUI
import Alamofire

struct SPB_NetworkService {
    
    @ObservedObject var vm: CivilCaseList_VM
    
    init(vm: CivilCaseList_VM){
        self.vm = vm
    }
    
    
    //MARK:- List
    
    func req_CivilCaseList(fromDate: Date = Date(), toDate: Date = Date()){
        
        vm.loading = true
        
        let sFromDate = fromDate.toString()
        let sToDate = toDate.toString()
        
        for page in 1...100 {
            let params: Parameters = [
                "adm_person_type": "all",
                "article": "",
                "civil_person_type": "all",
                "court_number": "",
                "criminal_person_type": "all",
                "date_from": sFromDate,
                "date_to": sToDate,
                "full_name": "",
                "id": "",
                "type": "adm",
                "page": "\(page)",
            ]
            
            let onSuccess: (String)->Void = { token in
                req_List(token, page)
            }
             
            let onError: ((NSError) -> Void) = {err in
                print(err)
            }
            SPB_AlamofireService.req_CivilCaseToken(params, onSuccess, onError)
        }
    }
    
    
    private func req_List(_ token: String, _ page: Int){
        let params: Parameters = [
            "id": token
        ]
    
        let onSuccess: ([CivilCase])->Void = { cases in
            for c in cases {
                if !vm.all.contains(where: {$0.caseID == c.caseID}) {
                    vm.all.append(c)
                    vm.model.append(c)
                   // vm.didRequestSucceeded_CivilCase(civilCase: c )
                }
            }
            if page == 100 {
                vm.didCCFinish()
                vm.loading = false
            }
        }
        
        let onError: ((NSError) -> Void) = {err in
            print(err)
            vm.loading = false
        }
        
        SPB_AlamofireService.req_CivilCaseList(params, onSuccess, onError)
    }
    
    
    
    
    //MARK:- Detail
    
    func req_CivilCaseDetail(id: String, courtSiteId: String){
        
        let onSuccess: (String)->Void = { token in
            req_Detail(token)
        }
        
        let onError: ((NSError) -> Void) = {err in
            print(err)
        }
        
        let params: Parameters = [
            "id": id,
            "court_site_id":courtSiteId
        ]
        
        SPB_AlamofireService.req_CivilCaseDetailToken(params, onSuccess, onError)
    }
    
    
    
    private func req_Detail(_ token: String){
        let params: Parameters = [
            "id": "\(token)"
        ]
    
        let onSuccess: (CivilCaseDetail)->Void = { detail in
            vm.detail = detail
        }
        
        let onError: ((NSError) -> Void) = {err in
            print(err)
        }
        
        
        let path = "https://mirsud.spb.ru/cases/api/results"
        print("\(path)/?id=\(token)")
        SPB_AlamofireService.req_CivilCaseDetail(params, onSuccess, onError)
    }
    
    
    
    //MARK:- Поиск пользователей
    /*
     Step 1: Подгрузка формы авторизации
     */
    func req_UsersSearch(caseID: String, search: String){
        let urlPath: String = "users.search"
        
        let params: Parameters = [
            "access_token": VK_Session.shared.token,
            "q": search,
            "city": "2",
            "fields":["last_seen","bdate","photo_200","photo_max","screen_name"],
            "count": 100,
            "v": VK_Session.versionAPI
        ]
        
        let onSuccess: ([VK_User])->Void = { vkUsers in
            for user in vkUsers {
                user.caseID = caseID
            }
        }
        
        let onError: ((NSError) -> Void) = {err in
            print(err)
        }
        
        SPB_AlamofireService.req_UserSearch(urlPath, params, onSuccess, onError)
    }
}
 
