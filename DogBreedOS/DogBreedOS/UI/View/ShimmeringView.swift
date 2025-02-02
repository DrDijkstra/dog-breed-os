//
//  ShimmeringView.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import SwiftUI

struct ShimmeringView: View {
    
    @State private var isShimmering = false

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.5), Color.gray.opacity(0.3)]),
                startPoint: .topLeading, endPoint: .bottomTrailing))
            .shine(isShimmering: $isShimmering)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isShimmering = true
                }
            }
    }
}

// MARK: - Preview
#Preview {
    ShimmeringView()
}
