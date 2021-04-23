//
//  DefendantRow.swift
//  MirSud
//
//  Created by Igor Ivanov on 16.04.2021.
//

import SwiftUI

struct DefendantRow: View {
    
    var rec: Defendant
    
    var body: some View {
        HStack(spacing: 16.0) {
            Text(rec.lastActivityDate.toString()).font(.system(size: 11))
            Text(rec.surname + " " + rec.firstName + " " +  rec.middleName).font(.system(size: 13))
            Spacer()
            Text("vk: \(rec.vkUsers.count)").font(.system(size: 11))
        }
        .padding()
    }
}

