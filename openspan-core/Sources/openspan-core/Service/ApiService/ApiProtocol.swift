//
//  ApiProtocol.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


import Foundation
import Alamofire

protocol ApiProtocol {
    func getBreedList(gwCallback: @escaping (ApiGateWayCallResult<ApiBreedData>) -> Void)
}

class ApiProtocolImpl: ApiProtocol {
    private let baseUrl: String
    private let session: Session

    init(baseUrl: String, timeoutInterval: TimeInterval = 40) {
        self.baseUrl = baseUrl
        
        // Configure session
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        let requestInterceptor = ApiInterceptor()
        self.session = Session(configuration: configuration, interceptor: requestInterceptor)
        
        // Set base URL for requests
        RequestRouter.baseUrl = baseUrl
    }

    func getBreedList(gwCallback: @escaping (ApiGateWayCallResult<ApiBreedData>) -> Void) {
        executeRequest(RequestRouter.breedList, gwCallback: gwCallback)
    }

    private func executeRequest<T: Decodable>(
        _ urlRequest: URLRequestConvertible,
        gwCallback: @escaping (ApiGateWayCallResult<T>) -> Void
    ) {
        session.request(urlRequest).responseData { [weak self] response in
            guard let self = self else { return }

            switch response.result {
            case .success(let data):
                self.printPrettyJSON(from: data, isSuccess: true)
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    gwCallback(.success(decodedResponse))
                } catch {
                    print("JSON Decoding Error: \(error)")
                    gwCallback(.failure(error))
                }
            case .failure(let error):
                if let data = response.data {
                    self.printPrettyJSON(from: data, isSuccess: false)
                }
                print("Request Failed: \(error)")
                gwCallback(.failure(error))
            }
        }
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
