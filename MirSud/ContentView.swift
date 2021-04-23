//
//  ContentView.swift
//  MirSud
//
//  Created by Igor Ivanov on 15.04.2021.
//

import SwiftUI

struct ContentView: View {
    
    let civilCaseList_VM = CivilCaseList_VM()
    let defendantList_VM = DefendantList_VM()
    let vk_Login_VM = VK_Login_VM()
    
    
    var body: some View {
        TabView {
            
            VK_Login_View().environmentObject(vk_Login_VM)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "bookmark.circle.fill")
                    Text("Авторизация")
                }
            
            CivilCaseList().environmentObject(civilCaseList_VM)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Гражданские Дела")
                }
            
            DefendantList().environmentObject(defendantList_VM)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "bookmark.circle.fill")
                    Text("Клиенты")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
