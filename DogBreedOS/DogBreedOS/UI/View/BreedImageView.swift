//
//  BreedImageView.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import SwiftUI
import OpenspanCore

struct BreedImageView: View {
    let breedImage: BreedImage
    let imageWidth: CGFloat
    
    @State private var isShimmering = false

    var body: some View {
        VStack {
            // Calculate aspect ratio
            let aspectRatio = breedImage.height / breedImage.width
            let imageHeight = imageWidth * aspectRatio
            
            // Check if image is a placeholder
            if breedImage.image == UIImage(named: "placeholder_image") {
                // Show shimmering effect if image is a placeholder
                ShimmeringView()
                    .frame(width: imageWidth, height: imageHeight)
                    .cornerRadius(8)
            } else {
                // Display the actual image
                Image(uiImage: breedImage.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageHeight)
                    .clipped()
                    .cornerRadius(8)
            }
            
            // Display the breed name below the image
            Text(breedImage.name)
                .font(.headline)
                .lineLimit(1)
                .frame(maxWidth: imageWidth, alignment: .center)
                .padding(.top, 4)
        }
        .padding() // Add padding inside the card
        .background(Color.white) // Set card background color
        .cornerRadius(12) // Rounded corners for the card
        .shadow(radius: 5) // Add a shadow for a card-like effect
        .frame(width: imageWidth) // Constrain the card width
    }
}

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

#Preview {
    let image = BreedImage(
               id: "1",
               name: "Golden Retriever",
               image: UIImage(named: "placeholder_image")!
           )
    BreedImageView(breedImage: image, imageWidth: 250)
}
