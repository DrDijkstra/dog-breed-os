//
//  DowloadService.swift
//  OneSpanCore
//
//  Created by Sanjay Dey on 2025-02-04.
//

import UIKit

protocol DownloadService {
    func downloadImage(url: String) async -> UIImage?
}

class DownloadServiceImpl: DownloadService {
    
    let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func downloadImage(url: String) async -> UIImage? {
        guard let url = URL(string: url) else {
            return nil
        }
        do {
            let data = try await apiService.downloadFile(url: url)
            return UIImage(data: data)
        }catch{
            return nil
        }
    }
}
