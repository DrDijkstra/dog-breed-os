//
//  BreedRow.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import SwiftUI
import OpenspanCore

struct BreedRow: View {
    let breed: BreedInfo
    let image: UIImage?
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(breed.name ?? "Unknown Breed")
                    .font(.headline)
                if let subBreeds = breed.subBreeds, !subBreeds.isEmpty {
                    Text("Sub-breeds: \(subBreeds.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    let sampleBreed = BreedInfo(name: "Labrador", subBreeds: ["Golden", "Black"])
    let sampleImage = UIImage(systemName: "photo")! // Placeholder image
    
    return BreedRow(breed: sampleBreed, image: sampleImage)
}
