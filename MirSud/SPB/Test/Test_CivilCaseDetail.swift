//
//  Test_CivilCaseDetail.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import Foundation

var civilCaseDetail: CivilCaseDetail? = load("spd-detail_1.json")

private func load(_ filename: String) -> CivilCaseDetail? {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    let res = Parser_CivilCaseDetail.parse(data)
    return res
}

