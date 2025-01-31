//
//  BreedImage.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//


import UIKit

class BreedImage: Identifiable, Equatable {
    let id: String
    let name: String
    var image: UIImage
    
    init(id: String, name: String, image: UIImage) {
        self.id = id
        self.name = name
        self.image = image
    }
    
    // Required for Equatable conformance
    static func == (lhs: BreedImage, rhs: BreedImage) -> Bool {
        lhs.id == rhs.id && lhs.image == rhs.image
    }
}

