//
//  NetworkQueue.swift
//  MirSud
//
//  Created by Igor Ivanov on 19.04.2021.
//

import UIKit
import Alamofire

class SPB_VK_LinkService {
    
    public static var shared = SPB_VK_LinkService()
    
    let queue = DispatchQueue(label: "thread-safe-obj", qos: .userInitiated, attributes: .concurrent)
    
    
    var mustHandle = false
    
    var vm: CivilCaseList_VM?
    
    var successCount = 0
    
    private init(){
        setupTimer()
    }
    
    
    func setup(_ vm: CivilCaseList_VM){
        self.vm = vm
    }
    
    struct VK_UserSearchPack {
        let caseID: String
        let userNameFilter: String
        let nonVkUserID: Int
    }

    private var requests: [VK_UserSearchPack] = []
    

    private var timer: Timer?


    func setupTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(vkUserSearch), userInfo: nil, repeats: true)
    }


    @objc func vkUserSearch() {
        
        var tmp: [VK_UserSearchPack] = []
        queue.sync {
            tmp = requests
        }
        
        if let req = tmp.popLast() {
            removeFromQueue(req)
            req_UsersSearch(caseID: req.caseID, search: req.userNameFilter, nonVkUserID: req.nonVkUserID)
        } else {
            if mustHandle {
                mustHandle = false
                vm?.didVKLinkingFinish()
            }
        }
    }

    
    public func addNewRequest(_ cases: [CivilCase]) {
        
        queue.async(flags: .barrier) {
            var packs = [VK_UserSearchPack]()
            for c in cases {
                let nonVkUserID = Defendant.getHashCode(from: c)
                let pack = VK_UserSearchPack(caseID: c.caseID, userNameFilter: c.defendantFirstName + " " + c.defendantSurname, nonVkUserID: nonVkUserID)
                packs.append(pack)
            }
            self.mustHandle = true
            self.requests.append(contentsOf: packs)
        }
    }
    
    
    private func removeFromQueue(_ req: VK_UserSearchPack) {
        queue.async(flags: .barrier) {
            self.requests.removeAll(where: {$0.caseID == req.caseID})
        }
    }
    
    
    //MARK:- Поиск пользователей
    /*
     Step 1: Подгрузка формы авторизации
     */
    func req_UsersSearch(caseID: String, search: String, nonVkUserID: Int){
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
            DispatchQueue.main.async(flags: .barrier) {
                self.vm?.currVkLinked += 1
            }
            for user in vkUsers {
                user.caseID = caseID
                self.vm?.didRequestSucceeded_VkUserSearch(user)
            }
            
            // Если VK-аккаунт не найден, то запоминаем запись
            if vkUsers.isEmpty {
                let noneVKUser = NonVkUser(id: nonVkUserID)
                RealmService.saveNonVKUsers(nonVKUsers: [noneVKUser], update: true)
            }
        }
        
        let onError: ((NSError) -> Void) = {err in
            print(err)
        }
        
        SPB_AlamofireService.req_UserSearch(urlPath, params, onSuccess, onError)
    }
}
