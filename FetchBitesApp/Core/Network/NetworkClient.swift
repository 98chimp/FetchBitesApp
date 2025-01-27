//
//  NetworkClient.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

struct NetworkClient {
    enum Endpoint {
        case recipes
        case malformedRecipes
        case emptyRecipes

        var url: URL? {
            switch self {
            case .recipes:
                return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
            case .malformedRecipes:
                return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
            case .emptyRecipes:
                return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
            }
        }
    }

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetch(endpoint: Endpoint) async throws -> Data {
        guard let url = endpoint.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(for: URLRequest(url: url))

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if httpResponse.statusCode == 204 {
            return "{ \"recipes\": [] }".data(using: .utf8) ?? Data()
        }

        return data
    }
}

// Custom error types
enum RecipeError: Error {
    case malformedData
    case emptyData
    case networkError(Error)
}
