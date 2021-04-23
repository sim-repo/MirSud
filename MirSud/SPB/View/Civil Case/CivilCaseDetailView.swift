//
//  CivilCaseDetail.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import SwiftUI

struct CivilCaseDetailView: View {
    @EnvironmentObject var vm: CivilCaseList_VM
    
    let id: Int
    @Binding var update: CivilCase.HandleStatus
    
    var body: some View {

            List {
                Group {
                    Text("Статус Дела изменить на:")
                    makeStatusPicker()
                }
                
                VStack(alignment: .leading) {
                    Group {
                        Text("Статус Обработки: \(vm.detail.handleStatus.rawValue)").font(.system(size: 16, weight: .heavy, design: .default))
                        Divider()
                        Text("Гражданское дело: \(vm.detail.caseID)")
                    }
                    Group {
                        Divider()
                        Text("")
                        Text("Сведения о сторонах по делу:").font(.system(size: 16, weight: .heavy, design: .default))
                        Divider()
                        Text("Истец: \(vm.detail.claimantName)")
                        Divider()
                        Text("Ответчик: \(vm.detail.defendantSurname) \(vm.detail.defendantFirstName) \(vm.detail.defendantMiddleName)")
                    }
                    Group {
                        Divider()
                        Text("")
                        Text("Основные сведения:").font(.system(size: 16, weight: .heavy, design: .default))
                        Divider()
                        Text("Дата поступления: \(vm.detail.createdDate)")
                        Divider()
                        Text("Дата принятия к производству: \(vm.detail.acceptedDate)")
                        Divider()
                        Text("Статус: \(vm.detail.status)")
                    }
                    Group {
                        Divider()
                        Text("№ участка: \(vm.detail.courtNumber)")
                        Divider()
                        Text("Район: \(vm.detail.districtName)")
                        Divider()
                        Text("Судья: \(vm.detail.judgeName)")
                        Divider()
                        Text("Сущность спора: \(vm.detail.description)")
                        Divider()
                        Text("УИД: \(vm.detail.judicialUID)")
                    }
                    Divider()
                    Text("")
                    Text("Сведения о движении дела:").font(.system(size: 16, weight: .heavy, design: .default))
                    ForEach(vm.detail.history) {history in
                        Divider()
                        Text("Дата события: \(history.date)")
                        Text("Время события: \(history.time)")
                        Text("Описание события / Результат события: \(history.status)")
                        Text("Дата публикации: \(history.publish_time)")
                        Text("")
                    }
                }
            }
        .font(.system(size: 13))
        .padding(.bottom, -100)
        .padding(.leading, 8)
        .padding(.leading, 8)
        
        .onAppear(perform: {
            vm.detailDidAppear(id)
        })
        .onDisappear {
            vm.detailDidDisappear()
        }
        .onChange(of: vm.detail.handleStatus) { newState in
            vm.detailDidChangeStatus(id, newState)
            update = newState
        }
    }
    
    
    func makeStatusPicker() -> some View {
        Picker("Статус", selection: $vm.detail.handleStatus) {
            ForEach(CivilCase.HandleStatus.allCases, id: \.rawValue) { status in
                Text(status.rawValue).tag(status)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
}

