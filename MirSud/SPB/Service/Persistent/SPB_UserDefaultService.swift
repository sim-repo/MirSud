//
//  UserDefault.swift
//  MirSud
//
//  Created by Igor Ivanov on 16.04.2021.
//

import Foundation


class SPB_UserDefaultService {
    
    static let shared = SPB_UserDefaultService()
    private init() {}
    
    
    enum RecEnum: String {
        case cc_handle_status, detail_cc_handle_status
    }
    
    //MARK:- Single
    func load_CC_Status(_ caseID: String) -> String? {
        return UserDefaults.standard.value(forKey: caseID + RecEnum.cc_handle_status.rawValue) as? String
    }
    
    func save_CC_Status(_ rec: CivilCase) {
        UserDefaults.standard.setValue(rec.handleStatus.rawValue, forKey: rec.caseID + RecEnum.cc_handle_status.rawValue)
    }
    
    
    //MARK:- Detail
    func load_CC_Detail_Status(_ caseID: String) -> String? {
        return UserDefaults.standard.value(forKey: caseID + RecEnum.detail_cc_handle_status.rawValue) as? String
    }
    
    func save_CC_Detail_Status(_ rec: CivilCaseDetail) {
        UserDefaults.standard.setValue(rec.handleStatus.rawValue, forKey: rec.caseID + RecEnum.detail_cc_handle_status.rawValue)
    }
}
