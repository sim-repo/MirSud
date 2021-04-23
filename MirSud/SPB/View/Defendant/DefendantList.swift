//
//  DefendantList.swift
//  MirSud
//
//  Created by Igor Ivanov on 16.04.2021.
//

import SwiftUI

struct DefendantList: View {
    
    @EnvironmentObject var vm: DefendantList_VM
    
    @State private var selectedStatus: Defendant.Status = .cold
    @State private var selectedSortBy: DefendantList_VM.SortBy = .name
    
    var body: some View {
        NavigationView {
            List {
                makeSortPicker()
                makeStatusPicker()
                
                ForEach(vm.model ) { rec in
                    NavigationLink(destination: DefendantDetail(id: rec.id, update: $selectedStatus).environmentObject(vm)) {
                        DefendantRow(rec: rec)
                    }
                }
            }.navigationTitle("Клиенты")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear{
            vm.viewDidAppear()
            UISegmentedControl.appearance().selectedSegmentTintColor = .yellow
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        }
        .onChange(of: selectedStatus) { newState in
            vm.filterDidChange(selectedStatus)
        }
        .onChange(of: selectedSortBy) { sortBy in
            vm.sortDidChange(sortBy)
        }
    }
    
    
    func makeStatusPicker() -> some View {
        Picker("Статус", selection: $selectedStatus) {
            ForEach(Defendant.Status.allCases, id: \.rawValue) { status in
                Text(status.rawValue).tag(status)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    
    func makeSortPicker() -> some View {
        Picker("Сортировка", selection: $selectedSortBy) {
            ForEach(DefendantList_VM.SortBy.allCases, id: \.rawValue) { status in
                Text(status.rawValue).tag(status)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct DefendantList_Previews: PreviewProvider {
    static var previews: some View {
        DefendantList()
    }
}
