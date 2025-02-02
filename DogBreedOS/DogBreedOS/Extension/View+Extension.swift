//
//  View+Extension.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import SwiftUI

public extension View {
    /// Adds an animated shimmering effect to any view, typically to show that an operation is in progress.
    @ViewBuilder func shimmering(
        active: Bool = true,
        animation: Animation = Shimmer.defaultAnimation,
        gradient: Gradient = Shimmer.defaultGradient,
        bandSize: CGFloat = 0.3,
        mode: Shimmer.Mode = .mask
    ) -> some View {
        if active {
            modifier(Shimmer(animation: animation, gradient: gradient, bandSize: bandSize, mode: mode))
        } else {
            self
        }
    }
}
