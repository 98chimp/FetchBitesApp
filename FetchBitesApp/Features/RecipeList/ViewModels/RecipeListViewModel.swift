//
//  RecipeListViewModel.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import Foundation

final class RecipeListViewModel: ObservableObject {
    enum ViewState: Equatable {
        static func == (lhs: RecipeListViewModel.ViewState, rhs: RecipeListViewModel.ViewState) -> Bool {
            lhs.value == rhs.value
        }

        var value: String? {
            return String(describing: self).components(separatedBy: "(").first
        }

        case loading
        case loaded
        case empty
        case error(Error)
    }

    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var state: ViewState = .loading

    private let repository: RecipeRepository

    init(repository: RecipeRepository = RecipeRepositoryImpl()) {
        self.repository = repository

        Task {
            await fetchRecipes()
        }
    }

    @MainActor
    func fetchRecipes() async {
        state = .loading

        do {
            let fetchedRecipes = try await repository.fetchRecipes()

            if fetchedRecipes.isEmpty {
                state = .empty
            } else {
                recipes = fetchedRecipes
                state = .loaded
            }
        } catch {
            state = .error(error)
            recipes = []
        }
    }
}

// MARK: - Repository Implementation
class RecipeRepositoryImpl: RecipeRepository {
    private let networkClient: NetworkClient
    private let endpoint: NetworkClient.Endpoint

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient

        if let endpointType = ProcessInfo.processInfo.environment["USE_ENDPOINT"] {
            switch endpointType {
            case "malformed": self.endpoint = .malformedRecipes
            case "empty": self.endpoint = .emptyRecipes
            default: self.endpoint = .recipes
            }
        } else {
            self.endpoint = .recipes
        }
    }

    func fetchRecipes() async throws -> [Recipe] {
        let data = try await networkClient.fetch(endpoint: endpoint)
        let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return response.recipes
    }
}
