//
//  ContentView.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import SwiftUI
import OpenspanCore

struct DogBreedsView: View {
    
    // MARK: - ViewModel
    @StateObject private var viewModel = DogBreedsViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    ForEach(viewModel.breeds, id: \.name) { breed in
                        BreedRow(
                            breed: breed,
                            image: viewModel.breedImages[breed.name ?? ""]
                        )
                    }
                }
            }
            .navigationTitle("Dog Breeds")
            .task {
                await viewModel.fetchAllBreedsAndImages()
            }
        }
    }
}

#Preview {
    DogBreedsView()
}
