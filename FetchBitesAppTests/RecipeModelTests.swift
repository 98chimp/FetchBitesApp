//
//  RecipeModelTests.swift
//  FetchBitesAppTests
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import XCTest
@testable import FetchBitesApp

final class RecipeModelTests: XCTestCase {
    func testRecipeDecoding() throws {
        // Given
        let json = """
        {
            "recipes": [
                {
                    "uuid": "123",
                    "name": "Test Recipe",
                    "cuisine": "Test Cuisine",
                    "photo_url_small": "https://example.com/small.jpg",
                    "photo_url_large": "https://example.com/large.jpg",
                    "source_url": "https://example.com/recipe",
                    "youtube_url": "https://youtube.com/watch?v=test"
                }
            ]
        }
        """.data(using: .utf8)!

        // When
        let response = try JSONDecoder().decode(RecipeResponse.self, from: json)

        // Then
        XCTAssertEqual(response.recipes.count, 1)
        XCTAssertEqual(response.recipes[0].name, "Test Recipe")
        XCTAssertEqual(response.recipes[0].cuisine, "Test Cuisine")
    }
}
