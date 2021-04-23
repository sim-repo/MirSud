//
//  CivilCaseList_VM.swift
//  MirSud
//
//  Created by Igor Ivanov on 16.04.2021.
//

import Combine
import SwiftUI
import AVFoundation

class CivilCaseList_VM: ObservableObject {
    
    
    enum LinkProgressEnum{
        case none, vk, detail, export
    }
    
    @Published var all: [CivilCase] = []
    
    @Published var model: [CivilCase] = []
    
    @Published var detail: CivilCaseDetail = CivilCaseDetail()
    
    @Published var startDate = Date()
    
    @Published var endDate = Date()
    
    @Published var startListRequest = false {
        didSet{
            reqList()
        }
    }
        
    @Published var loading: Bool = false
    
    //for progress:
    @Published var currLinkProgressEnum: LinkProgressEnum = .none
    @Published var currVkLinked: Double = 0
    
    var allVkLinked: Double = 0
    @Published var currDetailsLinked: Double = 0
    
    
    var vkUsers: [VK_User] = []
    var details: [CivilCaseDetail] = []
    
    @Published var accuracyFilter: Double = 2 // точность совпадения (в VK-аккаунт единицах), чем меньше, тем точнее
        
    var networkService: SPB_NetworkService?
    
    init(){
        setupNetwork()
    }
    
    func setupNetwork(){
        networkService = SPB_NetworkService(vm: self)
        SPB_VK_LinkService.shared.setup(self)
        SPB_DetailService.shared.setup(self)
    }
}


//MARK:- List Events
extension CivilCaseList_VM {
    
    func filterDidChange(_ val: CivilCase.HandleStatus){
        self.model = self.all.filter({$0.handleStatus == val})
    }
    
    
    func getRowColor(_ rec: CivilCase) -> Color {
        let defendantID = Defendant.getHashCode(from: rec)
        
        if let status = getDefendantStatus(defendantID) {
            switch status {
            case .cold:
                return .blue
            case .warm:
                return .orange
            case .hot:
                return .red
            case .useless:
                return .gray
            }
        }
        return .white
    }
    
    
    // Запрос списка новых дел
    private func reqList(){
        if startDate <= endDate {
            reset()
            networkService?.req_CivilCaseList(fromDate: startDate, toDate: endDate)
        }
    }
    
    // Сброс при каждом запросе reqList()
    private func reset(){
        all = []
        model = []
        vkUsers = []
        details = []
        currVkLinked = 0
        currDetailsLinked = 0
    }
    
    
    // Событие: подгружен весь список дел
    func didCCFinish(){
        guard !all.isEmpty else { return }
        let searchForVK = getSearchList()
        linkExistsVKs()
        
        if !searchForVK.isEmpty {
            currLinkProgressEnum = .vk
            allVkLinked = Double(searchForVK.count)
            SPB_VK_LinkService.shared.addNewRequest(searchForVK)
        } else {
            didVKLinkingFinish()
        }
    }
    
    
    /*
     Заполняет список Дел имеющимися VK IDs из DB.
     */
    private func linkExistsVKs() {
        for cc in all {
            let defendantID = Defendant.getHashCode(from: cc)
            if let defendant = loadDefendant(defendantID) {
                if !defendant.vkUsers.isEmpty {
                    cc.vkIDs = defendant.vkUsers.compactMap({$0.id})
                }
            }
        }
    }
    
    
    /*
     Выдает список Дел, по которым нужно сделать сетевые запросы к VK.
     
     Из списка исключаются:
        - раннее запомненные Non VK Users
        - записи, у которых в DB уже есть сведения по VK
     
     */
    private func getSearchList() -> [CivilCase] {
        var res: [CivilCase] = []
        //раннее запомненные Non VK Users
        if let vkNonUsers = RealmService.loadNonVKUsers() {
            for user in vkNonUsers {
                all.removeAll(where: { Defendant.getHashCode(from: $0) == user.id })
            }
        }
        //записи, у которых в DB уже есть сведения по VK
        for cc in all {
            let defendantID = Defendant.getHashCode(from: cc)
            if let defendant = loadDefendant(defendantID) {
                if defendant.vkUsers.isEmpty {
                    res.append(cc)
                }
            } else {
                res.append(cc)
            }
        }
        return res
    }
    
    
    // Событие: подгружен vk user
    func didRequestSucceeded_VkUserSearch(_ vkUser: VK_User) {
        if let civilCase = all.first(where: {$0.caseID == vkUser.caseID}) {
            civilCase.vkIDs.append(vkUser.id)
            vkUsers.append(vkUser)
        }
    }
    
    
    // Событие: все vk users подгружены
    func didVKLinkingFinish(){
        guard !all.isEmpty else { return }
        
        currLinkProgressEnum = .detail
        all = all.filter({ $0.vkIDs.count > 0 && $0.vkIDs.count <= Int(accuracyFilter) })
        model = model.filter({ $0.vkIDs.count > 0 && $0.vkIDs.count <= Int(accuracyFilter) })
        currVkLinked = Double(all.count)
        SPB_DetailService.shared.addNewRequest(all)
    }
    
    
    func startExport(){
        for cc in all {
            guard cc.handleStatus != .canceled && cc.handleStatus != .done  else { continue }
            let defendantID = Defendant.getHashCode(from: cc)
            if let status = getDefendantStatus(defendantID) {
                guard status != .useless else { continue }
            }
            cc.handleStatus = .in_progress
            SPB_UserDefaultService.shared.save_CC_Status(cc)
        }
        currLinkProgressEnum = .none
    }
    
    
    // Событие: детализация по делу подгружена
    func didRequestSucceeded_Detail(_ detail: CivilCaseDetail) {
        details.append(detail)
    }
    
    
    // Событие: подгружен весь список детализаций
    func didDetailsLinkingFinish(){
        guard !all.isEmpty else { return }
        currLinkProgressEnum = .export
        currDetailsLinked = Double(all.count)
        finalLink()
    }
    
    
    // Событие: конечное связывание
    private func finalLink(){
        
        var defendants: [Defendant] = []
        
        for cc in all {
            let defendantID = Defendant.getHashCode(from: cc)
            if loadDefendant(defendantID) == nil {
                let defendant = Defendant.create(from: cc)
                defendants.append(defendant)
            }
        }
        RealmService.saveDefendants(defendants: defendants, update: true)
        
        defendants = []
        
        for cc in all {
            let defendantID = Defendant.getHashCode(from: cc)
            let defendant = loadDefendant(defendantID)!
            
            let users = vkUsers.filter({$0.caseID == cc.caseID})
            for u in users {
                if !defendant.vkUsers.contains(u) {
                    defendant.vkUsers.append(u)
                }
            }

            let civilDetails = details.filter({$0.caseID == cc.caseID})
             
            for d in civilDetails {
                if !defendant.civilCases.contains(d) {
                    defendant.civilCases.append(d)
                }
            }

            RealmService.saveDefendants(defendants: [defendant], update: true)
        }
        AudioServicesPlayAlertSound(SystemSoundID(1333))
    }
}





//MARK:- Detail Events
extension CivilCaseList_VM {
    
    // сетевой запрос на детализацию Дела
    func detailDidAppear(_ id: Int){
        if let caseID = getCaseID(by: id),
           let courtSiteID = getCourtSiteID(by: id) {
            networkService?.req_CivilCaseDetail(id: caseID, courtSiteId: courtSiteID)
        }
    }
    
    // при закрытии экрана detail очищается путем присвоения 'пустышки'
    func detailDidDisappear(){
        detail = CivilCaseDetail()
    }
    
    
    func detailDidChangeStatus(_ id: Int, _ val: CivilCase.HandleStatus){
        guard validateDetail() else { return }
        if let cc = all.first(where: {$0.id == id}) {
            cc.handleStatus = val
            SPB_UserDefaultService.shared.save_CC_Status(cc)
        }

        detail.handleStatus = val
        
        // простая запись статуса Дела в user defaults:
        SPB_UserDefaultService.shared.save_CC_Detail_Status(detail)
        
        // при изменении статуса Дела - создается клиент, если его его нет в DB
        let defendantID = Defendant.getHashCode(from: detail)
        tryCreateDefendant(detail, defendantID)
    }
    

    // проверка, чтобы статус Дела фиксировался при реальной записи, а не пустышке
    private func validateDetail() -> Bool {
        return detail.defendantFirstName != "" &&
            detail.caseID != "" &&
            detail.courtNumber != ""
    }
}



//MARK:- Supplement
extension CivilCaseList_VM {
    private func getCaseID(by id: Int) -> String? {
        return model.first(where: {$0.id == id})?.caseID
    }
    
    
    private func getCourtSiteID(by id: Int) -> String? {
        return model.first(where: {$0.id == id})?.courtSiteId
    }
    
    
    private func tryCreateDefendant(_ rec: CivilCaseDetail, _ defendantID: Int) {
        if loadDefendant(defendantID) == nil {
            let defendant = Defendant.create(from: rec)
            RealmService.saveDefendants(defendants: [defendant], update: true)
        }
    }
    
    
    private func getDefendantStatus(_ defendantID: Int) -> Defendant.Status? {
        if let defendant = loadDefendant(defendantID) {
            return defendant.status
        }
        return nil
    }
    

    private func loadDefendant(_ defendantID: Int) -> Defendant? {
        if let defendants = RealmService.loadDefendants(filter: "id = \(defendantID)") {
            if !defendants.isEmpty {
                return defendants[0]
            }
        }
        return nil
    }
}
