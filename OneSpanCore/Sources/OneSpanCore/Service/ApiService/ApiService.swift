//
//  ApiProtocol.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


import Foundation
import Alamofire

protocol ApiService {
    func getBreedList() async throws -> ApiBreedData
    func getRandomBreedPhoto(request: ApiRandomBreedImageRequest) async throws -> ApiRandomBreedImageResponse
    func downloadFile(url: URL) async throws -> Data
}

class ApiServiceImpl: ApiService {
    
    private let baseUrl: String
    var session: Session

    init(baseUrl: String, timeoutInterval: TimeInterval = 40, requestInterceptor: RequestInterceptor? = nil) {
        self.baseUrl = baseUrl
        
        // Configure session
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        self.session = Session(configuration: configuration, interceptor: requestInterceptor)
        
        // Set base URL for requests
        RequestRouter.baseUrl = baseUrl
    }

    func getBreedList() async throws -> ApiBreedData {
        return try await executeRequest(RequestRouter.breedList)
    }
    
    func getRandomBreedPhoto(request: ApiRandomBreedImageRequest) async throws -> ApiRandomBreedImageResponse {
        return try await executeRequest(RequestRouter.randomPhoto(request: request))
    }
    
    func downloadFile(url: URL) async throws -> Data {
        return try await downloadFile(from: url.absoluteString)
    }

    private func executeRequest<T: Decodable>(_ urlRequest: URLRequestConvertible) async throws -> T {
        let dataTask = session.request(urlRequest).serializingDecodable(T.self)
        let response = await dataTask.response
        
        // Print the response for debugging
        if let data = response.data {
            printPrettyJSON(from: data, isSuccess: response.error == nil)
        }
        
        if let error = response.error {
            print("Request Failed: \(error)")
            throw error
        }
        
        return response.value!
    }
    
    func downloadFile(from url: String) async throws -> Data {
        let dataTask = session.request(url).serializingData()
        let response = await dataTask.response
        
        if let error = response.error {
            print("Download Failed: \(error)")
            throw error
        }
        
        guard let data = response.value else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }

    private func printPrettyJSON(from data: Data, isSuccess: Bool) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyPrintedData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                let statusEmoji = isSuccess ? "✅✅✅" : "❌❌❌"
                print("\(statusEmoji) ------------ Response ------------ \(statusEmoji)")
                print(prettyPrintedString)
            }
        } catch {
            print("Failed to prettify JSON: \(error)")
        }
    }
}
