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
    
    @State private var imageHeight: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            let aspectRatio = breedImage.height / breedImage.width
            let calculatedHeight = imageWidth * aspectRatio
            
            if breedImage.image == UIImage(named: "placeholder_image") {
                ShimmeringView()
                    .frame(width: imageWidth, height: calculatedHeight)
                    .cornerRadius(8)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            imageHeight = calculatedHeight
                        }
                    }
            } else {
                Image(uiImage: breedImage.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageHeight)
                    .clipped()
                    .cornerRadius(8)
                    .opacity(imageHeight > 0 ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            imageHeight = calculatedHeight
                        }
                    }
            }
            
            Text(breedImage.name)
                .font(.headline)
                .lineLimit(1)
                .frame(maxWidth: imageWidth, alignment: .center)
                .padding(.top, 4)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .padding()
        .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(width: imageWidth)
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
