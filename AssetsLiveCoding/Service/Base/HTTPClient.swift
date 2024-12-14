//
//  HTTPClient.swift
//  AssetsLiveCoding

import Foundation

enum HTTPClientError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

class HTTPClient {

    private let session: URLSession
    private let baseURL: URL

    // Initialize with a base URL and an optional custom URLSession
    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    // Async function to perform a request, construct the full URL with path and query parameters, and decode the JSON response
    func fetch<T: Decodable>(path: String, parameters: [String: String]? = nil) async throws -> T {
        // Construct the full URL
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        if let parameters = parameters {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = urlComponents?.url else {
            throw HTTPClientError.invalidURL
        }

        do {
            // Use async/await to fetch data
            let (data, response) = try await session.data(for: URLRequest(url: url))

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw HTTPClientError.invalidResponse
            }

            // Attempt to decode the JSON data
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                return decodedObject
            } catch let decodingError {
                throw HTTPClientError.decodingFailed(decodingError)
            }
        } catch {
            throw HTTPClientError.requestFailed(error)
        }
    }
}
