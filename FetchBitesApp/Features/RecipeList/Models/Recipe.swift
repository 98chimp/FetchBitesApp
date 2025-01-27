//
//  Recipe.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import Foundation

// Core protocols
protocol RecipeRepository {
    func fetchRecipes() async throws -> [Recipe]
}

// MARK: - Response Model
struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

// Domain Models with proper error handling
struct Recipe: Identifiable, Codable {
    let id: String
    let name: String
    let cuisine: String
    let photoURLSmall: String?
    let photoURLLarge: String?
    let sourceURL: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
