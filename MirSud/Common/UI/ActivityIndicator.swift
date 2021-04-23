//
//  ActivityIndicator.swift
//  MirSud
//
//  Created by Igor Ivanov on 18.04.2021.
//

import SwiftUI

struct ActivityIndicatorView: View {
    @Binding var isPresented:Bool
    var body: some View {
        if isPresented{
            ZStack{
                RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.1))
                ProgressView {
                    Text("loading...")
                        .font(.title2)
                }
            }.frame(width: 120, height: 120, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 25).stroke(Color.gray,lineWidth: 1))
        } else {
            ZStack{
            }.frame(width: 1, height: 1, alignment: .center)
        }
    }
}
