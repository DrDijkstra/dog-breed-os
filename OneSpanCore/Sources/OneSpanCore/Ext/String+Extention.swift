//
//  String+Extention.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import CryptoKit
import Foundation

extension String {
    func sha256() -> String {
        let data = Data(self.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
