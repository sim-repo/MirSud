//
//  MyButton.swift
//  MirSud
//
//  Created by Igor Ivanov on 19.04.2021.
//

import SwiftUI


struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 3 : 1)
            .animation(.spring())
            .font(.system(size: 13))
    }
}
