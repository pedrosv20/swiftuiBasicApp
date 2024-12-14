//
//  AssetsService.swift
//  AssetsLiveCoding

import Foundation

protocol AssetsServiceProtocol {
    func getAssets(by query: String?) async throws -> AssetsResponse
}

struct AssetsService: AssetsServiceProtocol {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    init() {
        self.httpClient = HTTPClient(baseURL: URL(string: "https://api.coincap.io/v2")!)
    }

    func getAssets(by query: String?) async throws -> AssetsResponse {
        try await httpClient.fetch(path: "assets", parameters: ["search": query ?? ""])
    }
}

#if DEBUG
class AssetsServiceMock: AssetsServiceProtocol {
    var modelToBeReturned: AssetsResponse?
    
    func getAssets(by query: String?) async throws -> AssetsResponse {
        try await Task.sleep(nanoseconds:1_000_000_000)
        if let modelToBeReturned = modelToBeReturned {
            return modelToBeReturned
        } else {
            throw NSError(domain: "", code: 0)
        }
        
        
    }
    
    
}
#endif
