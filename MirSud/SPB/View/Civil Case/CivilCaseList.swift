//
//  CivilCaseList.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import SwiftUI

struct CivilCaseList: View {
    var idx = 0
    @EnvironmentObject var vm: CivilCaseList_VM
    @State private var selectedStatus: CivilCase.HandleStatus = .new
    
    var body: some View {
        NavigationView {
            List {
                
                // Status Filter:
                makeStatusPicker()
                
                
                makeAccuracySlider()
                
                // Date Filter:
                HStack{
                    makeStartDatePicker()
                    makeEndDatePicker()
                    Button(action: { vm.startListRequest = true }){
                        Text("GO")
                    }
                    .buttonStyle(GrowingButton())
                }
                
                // Link Progress:
                if vm.currLinkProgressEnum == .vk {
                    makeVKLinkingProgress()
                }
                
                if vm.currLinkProgressEnum == .detail {
                    makeDetailsLinkingProgress()
                }
                
                if vm.currLinkProgressEnum == .export {
                    makeExportButton()
                }
                

                // Data:
                ForEach(groupBy(civilCases: vm.model).sorted(by: {$0.key > $1.key} ), id: \.key) { key, value in
                    Section(header: Text(key.toString())) {
                        ForEach(value.sorted(by: {$0.defendantSurname < $1.defendantSurname} ), id: \.self) { rec in
                            NavigationLink(destination: CivilCaseDetailView(id: rec.id, update: $selectedStatus).environmentObject(vm)) {
                                CivilCaseRow(civilCase: rec).environmentObject(vm)
                            }
                        }
                    }
                }
            }.navigationTitle("Гражданские Дела")
            .overlay(makeActivityIndicator(), alignment: .center)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: selectedStatus) { newState in
            vm.filterDidChange(selectedStatus)
        }
        .onAppear(){
            //Настраиваем стиль Picker
            UISegmentedControl.appearance().selectedSegmentTintColor = .yellow
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        }
    }
    
    
    func makeActivityIndicator() -> some View {
        ActivityIndicatorView(isPresented: $vm.loading)
    }
    
    
    func makeStartDatePicker() -> some View {
        DatePicker(selection: $vm.startDate, in: ...Date(), displayedComponents: .date) {
            Text("дата от:")
                .font(.system(size: 12))
        }
        .accentColor(Color.black)
        .transformEffect(.init(scaleX: 0.8, y: 0.8))
    }
    
    
    func makeEndDatePicker() -> some View {
        DatePicker(selection: $vm.endDate, in: ...Date(), displayedComponents: .date) {
            Text("дата до:")
                .font(.system(size: 12))
        }
        .accentColor(Color.black)
        .transformEffect(.init(scaleX: 0.8, y: 0.8))
    }
    
    
    func makeStatusPicker() -> some View {
        Picker("Статус", selection: $selectedStatus) {
            ForEach(CivilCase.HandleStatus.allCases, id: \.rawValue) { status in
                Text(status.rawValue).tag(status)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    
    func makeVKLinkingProgress() -> some View {
        ProgressView("VK linking: \(Int((vm.currVkLinked)*100/(vm.allVkLinked+1)))%", value: vm.currVkLinked, total: vm.allVkLinked)
            .font(.system(size: 13))
    }
    
    
    func makeDetailsLinkingProgress() -> some View {
        ProgressView("Details linking: \(Int((vm.currDetailsLinked)*100/Double(vm.all.count+1)))%", value: vm.currDetailsLinked, total: Double(vm.all.count))
            .font(.system(size: 13))
    }
    
    
    func makeExportButton() -> some View {
        Button(action: { vm.startExport() }){
            Text("Экспорт: \(Int(vm.currVkLinked)) записей")
        }
        .buttonStyle(GrowingButton())
    }
    
    
    func makeAccuracySlider() -> some View {
        HStack {
            Text("VK фактор: \(Int(vm.accuracyFilter))").font(.system(size: 10))
            Slider(value: $vm.accuracyFilter, in: 1...5, step: 1).accentColor(Color.yellow)
        }
    }
    
}


struct CivilCaseList_Previews: PreviewProvider {
    static var previews: some View {
        CivilCaseList()
    }
}
