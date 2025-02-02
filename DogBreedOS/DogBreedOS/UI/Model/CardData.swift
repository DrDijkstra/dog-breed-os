//
//  BreedImage.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import UIKit

class CardData: Identifiable, Hashable {
    let id: String
    let name: String
    var image: UIImage
    var width: CGFloat
    var height: CGFloat
    var isImageLoaded: Bool = false
    
    init(id: String, name: String, image: UIImage, isImageLoaded: Bool = false) {
        self.id = id
        self.name = name
        self.image = image
        self.width = image.size.width
        self.height = image.size.height
        self.isImageLoaded = isImageLoaded
    }
    
    // MARK: - Hashable Conformance
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Equatable Conformance
    
    static func == (lhs: CardData, rhs: CardData) -> Bool {
        lhs.id == rhs.id && lhs.image == rhs.image
    }
}
