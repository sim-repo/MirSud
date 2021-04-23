//
//  Date+Extensions.swift
//  MirSud
//
//  Created by Igor Ivanov on 16.04.2021.
//

import Foundation


extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
