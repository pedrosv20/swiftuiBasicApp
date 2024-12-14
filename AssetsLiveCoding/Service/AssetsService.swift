//
//  AssetsService.swift
//  AssetsLiveCoding

import Foundation

struct AssetsService {
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
