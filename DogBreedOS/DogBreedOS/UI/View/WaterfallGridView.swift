//
//  WaterfallGrid.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import SwiftUI
import UIKit

struct WaterfallGridView: View {
    
    @StateObject private var viewModel: WaterfallGridViewModel
    
    init(viewModel: WaterfallGridViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ForEach(viewModel.columns, id: \.self) { column in
                LazyVStack(spacing: 16) {
                    ForEach(column) { breedImage in
                        CardView(cardData: breedImage, imageWidth: viewModel.imageWidth)
                            .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    }
                }
            }
        }
        .padding(.horizontal, 4)
    }
}
// MARK: - Preview
#Preview {
    var breedImagesList: [CardData] = [
        CardData(id: "1", name: "Golden Retriever", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!),
        CardData(id: "2", name: "Bulldog", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!),
        CardData(id: "3", name: "Labrador", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!),
        CardData(id: "4", name: "Poodle", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!),
        CardData(id: "5", name: "Beagle", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!),
        CardData(id: "6", name: "Rottweiler", image: UIImage(named: "placeholder_image") ?? UIImage(systemName: "photo")!)
    ]
    
    let model = WaterfallGridViewModel(numberOfColumns: 2)
    model.updateCardImagesList(breedImagesList) // Ensure the model has data before passing it
    return WaterfallGridView(viewModel: model)
}

