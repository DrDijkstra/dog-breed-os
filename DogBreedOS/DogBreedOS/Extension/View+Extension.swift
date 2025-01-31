//
//  View+Extension.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import SwiftUI

extension View {
    func shine(isShimmering: Binding<Bool>) -> some View {
        self.overlay(
            GeometryReader { geometry in
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.7), Color.white.opacity(0)]),
                        startPoint: .top, endPoint: .bottom))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: isShimmering.wrappedValue ? geometry.size.width : -geometry.size.width)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: isShimmering.wrappedValue)
            }
        )
    }
}
