//
//  MockBreedImageProvider.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import UIKit

class MockBreedImageProvider {

    
    var breedImagesList: [BreedImage] = [
        BreedImage(id: "1", name: "Golden Retriever", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!),
        BreedImage(id: "2", name: "Bulldog", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!),
        BreedImage(id: "3", name: "Labrador", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!),
        BreedImage(id: "4", name: "Poodle", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!),
        BreedImage(id: "5", name: "Beagle", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!),
        BreedImage(id: "6", name: "Rottweiler", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!)
    ]
}
