//
//  CacheClearButton.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import SwiftUI

struct CacheClearButton: View {
    @ObservedObject var viewModel: DogBreedsViewModel
    
    var body: some View {
        Button(action: {
            Task {
                await viewModel.clearCacheAndReload()
            }
        }) {
            Image(systemName: "arrow.clockwise")
                .font(.headline)
        }
    }
}

