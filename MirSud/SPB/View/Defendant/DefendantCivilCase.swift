//
//  DefendantCivilCase.swift
//  MirSud
//
//  Created by Igor Ivanov on 21.04.2021.
//

import SwiftUI

struct DefendantCivilCaseRow: View {
    
    var detail: CivilCaseDetail
    @EnvironmentObject var vm: DefendantList_VM
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Group {
                    Text("Статус Дела изменить на:")
                    makeStatusPicker()
                }
                Group {
                    Text("Гражданское дело: \(detail.caseID)").font(.system(size: 16, weight: .heavy, design: .default))
                }
                Group {
                    Divider()
                    Text("")
                    Text("Сведения о сторонах по делу:").font(.system(size: 14, weight: .heavy, design: .default))
                    Divider()
                    Text("Истец: \(detail.claimantName)")
                    Divider()
                    Text("Ответчик: \(detail.defendantSurname) \(detail.defendantFirstName) \(detail.defendantMiddleName)")
                }
                Group {
                    Divider()
                    Text("")
                    Text("Основные сведения:").font(.system(size: 14, weight: .heavy, design: .default))
                    Divider()
                    Text("Дата поступления: \(detail.createdDate)")
                    Divider()
                    Text("Дата принятия к производству: \(detail.acceptedDate)")
                    Divider()
                    Text("Статус: \(detail.status)")
                }
                Group {
                    Divider()
                    Text("№ участка: \(detail.courtNumber)")
                    Divider()
                    Text("Район: \(detail.districtName)")
                    Divider()
                    Text("Судья: \(detail.judgeName)")
                    Divider()
                    Text("Сущность спора: \(detail.description)")
                    Divider()
                    Text("УИД: \(detail.judicialUID)")
                }
                Divider()
                Text("")
                Text("Сведения о движении дела:").font(.system(size: 14, weight: .heavy, design: .default))
                ForEach(detail.history) {history in
                    Divider()
                    Text("Дата события: \(history.date)")
                    Text("Время события: \(history.time)")
                    Text("Описание события / Результат события: \(history.status)")
                    Text("Дата публикации: \(history.publish_time)")
                    Text("")
                }
            }
            .onChange(of: vm.selectedCivilCase.handleStatus) { newState in
                vm.ccDetailDidChangeStatus(newState)
            }
            .onAppear(perform: {
                vm.ccDetailDidAppear(detail.caseID)
            })
            
        }
        .font(.system(size: 13))
        .padding(.bottom, -100)
        .padding(.leading, 8)
        .padding(.leading, 8)
        
    }
    
    
    func makeStatusPicker() -> some View {
        Picker("Статус", selection: $vm.selectedCivilCase.handleStatus) {
            ForEach(CivilCase.HandleStatus.allCases, id: \.rawValue) { status in
                Text(status.rawValue).tag(status)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}


