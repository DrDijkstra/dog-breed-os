//
//  BreedImageView.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import SwiftUI
import OpenspanCore

struct CardView: View {
    let cardData: CardData
    let imageWidth: CGFloat
    
    @State private var imageHeight: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            let aspectRatio = cardData.height / cardData.width
            let calculatedHeight = imageWidth * aspectRatio
            
            if !cardData.isImageLoaded {
                ShimmeringView()
                    .frame(width: imageWidth, height: calculatedHeight)
                    .cornerRadius(8)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            imageHeight = calculatedHeight
                        }
                    }
            } else {
                Image(uiImage: cardData.image)
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
            
            Text(cardData.name)
                .font(.headline)
                .lineLimit(1)
                .frame(maxWidth: imageWidth, alignment: .center)
                .padding(.top, 2)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .padding(12)
        .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(width: imageWidth)
    }
}

#Preview {
    let image = CardData(
        id: "1",
        name: "Golden Retriever",
        image: UIImage(named: "placeholder_image")!
    )
    CardView(cardData: image, imageWidth: 250)
}
