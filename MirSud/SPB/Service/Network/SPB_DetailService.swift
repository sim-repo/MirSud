//
//  SPB_DetailService.swift
//  MirSud
//
//  Created by Igor Ivanov on 20.04.2021.
//


import UIKit
import Alamofire

class SPB_DetailService {
    
    public static var shared = SPB_DetailService()
    
    let queue = DispatchQueue(label: "thread-safe-obj", qos: .userInitiated, attributes: .concurrent)

    var vm: CivilCaseList_VM?
    
    var successCount = 0
    
    var mustHandle = false
    
    private init(){
        setupTimer()
    }
    
    
    func setup(_ vm: CivilCaseList_VM){
        self.vm = vm
    }
    
    struct DetailSearchPack {
        let caseID: String
        let courtSiteId: String
    }
    
    private var requests: [DetailSearchPack] = []

    private var timer: Timer?


    func setupTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(vkDetailSearch), userInfo: nil, repeats: true)
    }


    @objc func vkDetailSearch() {
        
        guard mustHandle else { return }
        var tmp: [DetailSearchPack] = []
        queue.sync {
            tmp = requests
        }
        
        if let req = tmp.popLast() {
            removeFromQueue(req)
            req_CivilCaseDetail(id: req.caseID, courtSiteId: req.courtSiteId)
        } else {
            if mustHandle {
                mustHandle = false
                vm?.didDetailsLinkingFinish()
            }
        }
    }

    
    public func addNewRequest(_ cases: [CivilCase]) {
        queue.async(flags: .barrier) {
            var packs = [DetailSearchPack]()
            for c in cases {
                let pack = DetailSearchPack(caseID: c.caseID, courtSiteId: c.courtSiteId)
                packs.append(pack)
            }
            self.mustHandle = true
            self.requests.append(contentsOf: packs)
        }
    }
    
    
    private func removeFromQueue(_ req: DetailSearchPack) {
        queue.async(flags: .barrier) {
            self.requests.removeAll(where: {$0.caseID == req.caseID})
        }
    }
    
    
    //MARK:- Detail
    
    func req_CivilCaseDetail(id: String, courtSiteId: String){
        
        let onSuccess: (String)->Void = { token in
            self.req_Detail(token)
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
            DispatchQueue.main.async(flags: .barrier) {
                self.vm?.currDetailsLinked += 1
            }
            self.vm?.didRequestSucceeded_Detail(detail)
        }
        
        let onError: ((NSError) -> Void) = {err in
            print(err)
        }
        
        
      //  let path = "https://mirsud.spb.ru/cases/api/results"
    //    print("\(path)/?id=\(token)")
        SPB_AlamofireService.req_CivilCaseDetail(params, onSuccess, onError)
    }
}

