//
//  Defendant_VM.swift
//  MirSud
//
//  Created by Igor Ivanov on 16.04.2021.
//

import Combine
import SwiftUI
import AVFoundation

class DefendantList_VM: ObservableObject {
    
    enum SortBy: String, CaseIterable {
        case activity="активность", name="ФИО", vkAccuracy="vk-фактор"
    }
    
    @Published var all: [Defendant] = []
    @Published var model: [Defendant] = []
    @Published var detail: Defendant = Defendant()
    @Published var selectedCivilCase: CivilCaseDetail = CivilCaseDetail()
    
    
    @Published var mustOpenWebView: Bool = false
    var selectedVKid = 0
    
    
    init(){
        loadFromDB()
    }
    
    func loadFromDB(){
        if let defendants = RealmService.loadDefendants() {
            model = defendants.filter({$0.status == .cold})
            all = defendants
        }
    }
}


//MARK:- List Events
extension DefendantList_VM {
    
    func viewDidAppear(){
        loadFromDB()
    }
    
    func filterDidChange(_ val: Defendant.Status){
        model = all.filter({$0.status == val})
    }
    
    func sortDidChange(_ val: SortBy){
        var tmp = model.map{$0}
        switch val {
        case .name:
            tmp.sort(by: {$0.surname < $1.surname})
        case .activity:
            tmp.sort(by: {$0.lastActivityDate > $1.lastActivityDate})
        case .vkAccuracy:
            tmp.sort(by: {$0.vkUsers.count < $1.vkUsers.count})
        }
        model = tmp.map{$0}
    }
}



//MARK:- Detail Events
extension DefendantList_VM {
    
    func detailDidAppear(_ id: Int){
        if let d = model.first(where: {$0.id == id}) {
            detail = d
        }
    }
    
    func detailDidDisappear(){
    }
    
    
    func detailDidChangeStatus(){
        RealmService.saveDefendants(defendants: [detail], update: true)
    }
    
    
    func detailDidTapVK(vkID: Int){
        mustOpenWebView = true
        selectedVKid = vkID
    }
    
    
    func detailDidCloseWebView(){
        mustOpenWebView = false
        selectedVKid = 0
    }
    
    
    func detailDidTapRemoveVK(vkID: Int){
        let users = detail.vkUsers.filter{$0.id != vkID}
        
        if !users.isEmpty {
            detail.vkUsers = users
            RealmService.saveDefendants(defendants: [detail], update: true)
            AudioServicesPlayAlertSound(SystemSoundID(1057))
        }
    }
}


//MARK:- CC Detail Events
extension DefendantList_VM {

    func ccDetailDidChangeStatus(_ val: CivilCase.HandleStatus){
        selectedCivilCase.handleStatus = val
        SPB_UserDefaultService.shared.save_CC_Detail_Status(selectedCivilCase)
        detail.civilCases.first(where: {$0.caseID == selectedCivilCase.caseID})?.handleStatus = val
        RealmService.saveDefendants(defendants: [detail], update: true)
    }
    
    
    func ccDetailDidAppear(_ caseID: String){
        if let cc = detail.civilCases.first(where: {$0.caseID == caseID}) {
            selectedCivilCase = cc
        }
    }
}
