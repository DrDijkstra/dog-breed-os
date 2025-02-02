//
//  Shimmer.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-02-02.
//

import SwiftUI

/// A view modifier that applies an animated "shimmer" to any view, typically to show that an operation is in progress.
public struct Shimmer: ViewModifier {
    public enum Mode {
        case mask
        case overlay(blendMode: BlendMode = .sourceAtop)
        case background
    }

    private let animation: Animation
    private let gradient: Gradient
    private let min, max: CGFloat
    private let mode: Mode
    @State private var isInitialState = true
    @Environment(\.layoutDirection) private var layoutDirection

    /// Initializes the modifier with a custom animation and gradient.
    public init(
        animation: Animation = Self.defaultAnimation,
        gradient: Gradient = Self.defaultGradient,
        bandSize: CGFloat = 0.3,
        mode: Mode = .mask
    ) {
        self.animation = animation
        self.gradient = gradient
        self.min = 0 - bandSize
        self.max = 1 + bandSize
        self.mode = mode
    }

    /// Default animation for shimmer effect.
    public static let defaultAnimation = Animation.linear(duration: 1.5).delay(0.25).repeatForever(autoreverses: false)

    /// Default gradient for the shimmer mask.
    public static let defaultGradient = Gradient(colors: [
        .black.opacity(0.3),
        .black,
        .black.opacity(0.3)
    ])

    /// Calculates the start point of the gradient based on layout direction.
    private var startPoint: UnitPoint {
        layoutDirection == .rightToLeft
            ? (isInitialState ? UnitPoint(x: max, y: min) : UnitPoint(x: 0, y: 1))
            : (isInitialState ? UnitPoint(x: min, y: min) : UnitPoint(x: 1, y: 1))
    }

    /// Calculates the end point of the gradient based on layout direction.
    private var endPoint: UnitPoint {
        layoutDirection == .rightToLeft
            ? (isInitialState ? UnitPoint(x: 1, y: 0) : UnitPoint(x: min, y: max))
            : (isInitialState ? UnitPoint(x: 0, y: 0) : UnitPoint(x: max, y: max))
    }

    public func body(content: Content) -> some View {
        applyingGradient(to: content)
            .animation(animation, value: isInitialState)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    isInitialState = false
                }
            }
    }

    @ViewBuilder private func applyingGradient(to content: Content) -> some View {
        let gradient = LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
        switch mode {
        case .mask:
            content.mask(gradient)
        case let .overlay(blendMode):
            content.overlay(gradient.blendMode(blendMode))
        case .background:
            content.background(gradient)
        }
    }
}

#if DEBUG
struct Shimmer_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text("SwiftUI Shimmer").shimmering()
            VStack(alignment: .leading) {
                Text("Loading...").font(.title)
                Text(String(repeating: "Shimmer", count: 12))
                    .redacted(reason: .placeholder)
            }
            .frame(maxWidth: 200)
            .shimmering()

            VStack(alignment: .leading) {
                Text("مرحبًا")
                Text("← Right-to-left layout direction")
                Text("שלום")
            }
            .font(.largeTitle)
            .shimmering()
            .environment(\.layoutDirection, .rightToLeft)

            Text("Custom Gradient Mode").bold()
                .font(.largeTitle)
                .shimmering(
                    gradient: Gradient(colors: [.clear, .orange, .white, .green, .clear]),
                    bandSize: 0.5,
                    mode: .overlay()
                )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
