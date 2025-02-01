//
//  WaterfallGridViewModel.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//


import UIKit
import Combine

protocol BreedImageProvider: AnyObject {
   func updateBreedImagesList(_ breedImages: [BreedImage])
}

class WaterfallGridViewModel: ObservableObject , BreedImageProvider{
    func updateBreedImagesList(_ breedImages: [BreedImage]) {
        updateColumns(with: breedImages)
    }
    
    @Published var columns: [[BreedImage]] = []
    
    private let numberOfColumns: Int
    private var cancellables = Set<AnyCancellable>()
    
    init(numberOfColumns: Int) {
        self.numberOfColumns = numberOfColumns
    }
    
    private func updateColumns(with breedImages: [BreedImage]) {
        let newColumns = distributeImagesAcrossColumns(breedImages: breedImages)
        print("Updating columns with \(newColumns.count) columns and total \(breedImages.count) images")
        
        DispatchQueue.main.async {
            self.columns = newColumns
            print("Columns updated. First column count: \(self.columns.first?.count ?? 0)")
        }
    }
    
    private func distributeImagesAcrossColumns(breedImages: [BreedImage]) -> [[BreedImage]] {
        var columns: [[BreedImage]] = Array(repeating: [], count: numberOfColumns)
        
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
    
    private func calculateImageHeight(for breedImage: BreedImage) -> CGFloat {
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
