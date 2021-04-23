//
//  GroupBy.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import Foundation


func groupBy(civilCases: [CivilCase]) -> [Date: [CivilCase]] {
    let res: [Date: [CivilCase]]  = [:]
    let groupedByDate = civilCases.reduce(into: res) { acc, cur in
        let components = Calendar.current.dateComponents([.year, .month, .day], from: cur.date)
        let date = Calendar.current.date(from: components)!
        let existing = acc[date] ?? []
        acc[date] = existing + [cur]
    }
    return groupedByDate
}
