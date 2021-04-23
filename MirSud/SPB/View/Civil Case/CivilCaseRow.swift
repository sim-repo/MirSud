//
//  CivilCaseRow.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import SwiftUI

struct CivilCaseRow: View {
    var civilCase: CivilCase

    @EnvironmentObject var vm: CivilCaseList_VM
    
    var body: some View {
        HStack(spacing: 32.0) {
            HStack(spacing: 4) {
                Circle()
                    .fill(vm.getRowColor(civilCase))
                    .frame(width: 10, height: 10)
                Text(civilCase.caseID)
            }
            Text(civilCase.defendantSurname + " " + civilCase.defendantFirstName + " " +  civilCase.defendantMiddleName)
        }
        .font(.system(size: 13))
        .padding()
    }
}



