//
//  DefendantHistory.swift
//  MirSud
//
//  Created by Igor Ivanov on 17.04.2021.
//


import Foundation

class DefendantHistory: Identifiable, Hashable {

    var id: Int = 0
    var defendantID: Int = 0 // hash code
    var caseID: String = "" // Дело Номер
    var civilCaseStartDate: Date = Date()
    var civilCaseEndDate: Date = Date()
    var civilCaseStatus: CivilCase.HandleStatus = .new
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: DefendantHistory, rhs: DefendantHistory) -> Bool {
        lhs.id == rhs.id
    }
}
