//
//  RecipeViewModelTests.swift
//  FetchBitesAppTests
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import XCTest
@testable import FetchBitesApp

final class RecipeViewModelTests: XCTestCase {
    var sut: RecipeListViewModel!
    var mockRepository: MockRecipeRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockRecipeRepository()
        sut = RecipeListViewModel(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testFetchRecipes_Success() async throws {
        // Given
        let expectedRecipes = [Recipe.preview, Recipe.previewNoVideo]
        mockRepository.mockResult = expectedRecipes

        // When
        await sut.fetchRecipes()

        // Then
        XCTAssertEqual(sut.recipes.count, expectedRecipes.count)
        XCTAssertEqual(sut.state, .loaded)
    }

    func testFetchRecipes_EmptyResponse() async throws {
        // Given
        mockRepository.mockResult = []

        // When
        await sut.fetchRecipes()

        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertEqual(sut.state, .empty)
    }

    func testFetchRecipes_NetworkError() async {
        // Given
        mockRepository.mockError = NSError(domain: "test", code: -1)

        // When
        await sut.fetchRecipes()

        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertEqual(sut.state, .error(mockRepository.mockError!))
    }

    func testFetchRecipes_MalformedData() async throws {
        // Given
        mockRepository.mockError = RecipeError.malformedData

        // When
        await sut.fetchRecipes()

        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertEqual(sut.state, .error(RecipeError.malformedData))
    }

    func testFetchRecipes_EmptyDataEndpoint() async throws {
        // Given
        mockRepository.mockResult = []

        // When
        await sut.fetchRecipes()

        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertEqual(sut.state, .empty)
    }

    func testRecipeSort_Alphabetical() async throws {
        // Given
        let recipes = [
            Recipe.makeTestRecipe(name: "Zebra Cake"),
            Recipe.makeTestRecipe(name: "Apple Pie")
        ]
        mockRepository.mockResult = recipes

        // When
        await sut.fetchRecipes()
        let sortedRecipes = sut.recipes.sorted { $0.name < $1.name }

        // Then
        XCTAssertEqual(sortedRecipes.first?.name, "Apple Pie")
        XCTAssertEqual(sortedRecipes.last?.name, "Zebra Cake")
    }

    func testRecipeSort_ByCuisine() async throws {
        // Given
        let recipes = [
            Recipe.makeTestRecipe(cuisine: "Italian"),
            Recipe.makeTestRecipe(cuisine: "American")
        ]
        mockRepository.mockResult = recipes

        // When
        await sut.fetchRecipes()
        let groupedRecipes = Dictionary(grouping: sut.recipes) { $0.cuisine }

        // Then
        XCTAssertNotNil(groupedRecipes["Italian"])
        XCTAssertNotNil(groupedRecipes["American"])
    }
}

// Helper for creating test recipes
extension Recipe {
    static func makeTestRecipe(
        id: String = UUID().uuidString,
        name: String = "Test Recipe",
        cuisine: String = "Test Cuisine",
        photoURLSmall: String? = nil,
        photoURLLarge: String? = nil,
        sourceURL: String? = nil,
        youtubeURL: String? = nil
    ) -> Recipe {
        Recipe(
            id: id,
            name: name,
            cuisine: cuisine,
            photoURLSmall: photoURLSmall,
            photoURLLarge: photoURLLarge,
            sourceURL: sourceURL,
            youtubeURL: youtubeURL
        )
    }
}
