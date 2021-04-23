//
//  DefendantDetail.swift
//  MirSud
//
//  Created by Igor Ivanov on 17.04.2021.
//

import SwiftUI

struct DefendantDetail: View {
    
    @EnvironmentObject var vm: DefendantList_VM
    
    let id: Int
    @Binding var update: Defendant.Status
    @State var update2: Int = 0
    
    var body: some View {
        Group {
            if vm.mustOpenWebView {
                if vm.selectedVKid != 0 {
                    VStack {
                        Button(action: {
                            vm.detailDidCloseWebView()
                        }) {
                            Text("Close")
                        }.buttonStyle(GrowingButton())
                        CommonWebview(url: URL(string: "https://vk.com/id\(vm.selectedVKid)")!)
                    }
                }
            }
            else {
                    VStack(alignment: .leading) {
                        Group {
                            Divider()
                            Text("Статус Клиента изменить на:")
                            makeStatusPicker()
                        }
                        Group {
                            Divider()
                            Text("vk: \(update2)")
                            ForEach(vm.detail.vkUsers, id: \.self) {user in
                                HStack(spacing:16) {
                                    
                                    if let u = URL(string:user.avaURL200?.absoluteString ?? "") {
                                        AsyncImage(url: u, placeholder: { Text("Loading ...") }, image: { Image(uiImage: $0).resizable()})
                                            .onTapGesture {
                                                vm.detailDidTapVK(vkID: user.id)
                                            }
                                            .scaledToFit()
                                            .frame(width: 50,height:50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.yellow, lineWidth: 2))
                                    }
                                    Text("\(user.id)")
                                    Spacer()
                                    Button(action: {
                                        vm.detailDidTapRemoveVK(vkID: user.id)
                                        update2 -= 1
                                    }) {
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 20, weight: .ultraLight))
                                    }
                                }
                            }
                        }
                        
                        Group {
                            Divider()
                            Text("Telegram:")
                            TextField("ok id:", text: $vm.detail.telegramID)
                        }
                        
                        Group {
                            Divider()
                            Text("Тел.Но.:")
                            TextField("Тел.Но.:", text: $vm.detail.phone)
                        }
                        
                        Group {
                            Text("Связанные Дела:")
                            List{
                                ForEach(vm.detail.civilCases, id: \.self) {cc in
                                    NavigationLink(destination: DefendantCivilCaseRow(detail: cc).environmentObject(vm)) {
                                        HStack(spacing: 16) {
                                            Text(cc.createdDate)
                                            Text("\(cc.caseID)")
                                            Spacer()
                                            Text(cc.handleStatus.rawValue)
                                        }
                                    }
                                }
                            }
                        }
                    }.font(.system(size: 13))
                }
            
        }
        .navigationTitle("\(vm.detail.surname) \(vm.detail.firstName) \(vm.detail.middleName)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            vm.detailDidAppear(id)
            update2 = vm.detail.vkUsers.count
            //Настраиваем стиль Picker
            UISegmentedControl.appearance().selectedSegmentTintColor = .yellow
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        })
        .onDisappear {
            vm.detailDidDisappear()
        }
        .onChange(of: vm.detail.status) { newState in
            vm.detailDidChangeStatus()
            update = newState
        }
        .padding(EdgeInsets(top: 32, leading: 16, bottom: 0, trailing: 16))
    }
    
    
    func makeStatusPicker() -> some View {
        Picker("Статус", selection: $vm.detail.status) {
            ForEach(Defendant.Status.allCases, id: \.rawValue) { status in
                Text(status.rawValue).tag(status)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

