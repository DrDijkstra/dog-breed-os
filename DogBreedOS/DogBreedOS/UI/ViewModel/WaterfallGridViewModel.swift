//
//  WaterfallGridViewModel.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//


import UIKit
import Combine

protocol CardImageProvider: AnyObject {
   func updateCardImagesList(_ breedImages: [CardData])
}

class WaterfallGridViewModel: ObservableObject , CardImageProvider{
    func updateCardImagesList(_ breedImages: [CardData]) {
        updateColumns(with: breedImages)
    }
    
    @Published var columns: [[CardData]] = []
    
    private let numberOfColumns: Int
    private var cancellables = Set<AnyCancellable>()
    
    init(numberOfColumns: Int) {
        self.numberOfColumns = numberOfColumns
    }
    
    private func updateColumns(with breedImages: [CardData]) {
        let newColumns = distributeImagesAcrossColumns(breedImages: breedImages)
        
        DispatchQueue.main.async {
            self.columns = newColumns
        }
    }
    
    private func distributeImagesAcrossColumns(breedImages: [CardData]) -> [[CardData]] {
        var columns: [[CardData]] = Array(repeating: [], count: numberOfColumns)
        
        var columnHeights: [CGFloat] = Array(repeating: 0, count: numberOfColumns)
        
        for breedImage in breedImages {
            let imageHeight = calculateImageHeight(for: breedImage)
            
            if let minHeightIndex = columnHeights.indices.min(by: { columnHeights[$0] < columnHeights[$1] }) {
                columns[minHeightIndex].append(breedImage)
                columnHeights[minHeightIndex] += imageHeight
            }
        }
        
        return columns
    }
    
    private func calculateImageHeight(for breedImage: CardData) -> CGFloat {
        let image = breedImage.image
        let aspectRatio = image.size.height / image.size.width
        return imageWidth * aspectRatio
    }
    
    var imageWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing = CGFloat(numberOfColumns - 1) * 48 // Spacing between columns
        let totalPadding: CGFloat = 32 // Horizontal padding (16 on each side)
        return (screenWidth - totalSpacing - totalPadding) / CGFloat(numberOfColumns)
    }
}
