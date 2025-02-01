//
//  CacheClearButton.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import SwiftUI

struct CacheClearButton: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "arrow.clockwise")
                .font(.headline)
        }
    }
}

#Preview {
    CacheClearButton(action: ({}))
}
