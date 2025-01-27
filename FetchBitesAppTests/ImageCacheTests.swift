//
//  ImageCacheTests.swift
//  FetchBitesAppTests
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import XCTest
@testable import FetchBitesApp

final class ImageCacheTests: XCTestCase {
    var sut: ImageCache!

    override func setUp() {
        super.setUp()
        sut = ImageCache()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testImageCache_InsertAndRetrieve() async throws {
        // Given
        let testImage = UIImage(systemName: "star.fill")!
        let testURL = URL(string: "https://example.com/test.jpg")!

        // When
        await sut.insert(testImage, for: testURL)
        let cachedImage = await sut.get(for: testURL)

        // Then
        XCTAssertNotNil(cachedImage)
    }

    func testImageCache_Clear() async {
        // Given
        let testImage = UIImage(systemName: "star.fill")!
        let testURL = URL(string: "https://example.com/test.jpg")!
        await sut.insert(testImage, for: testURL)

        // When
        await sut.clear()
        let cachedImage = await sut.get(for: testURL)

        // Then
        XCTAssertNil(cachedImage)
    }

    func testEvictionPolicy_ShouldRemoveCorrectImage() async {
        // Given
        let image1 = UIImage(systemName: "house")!
        let image2 = UIImage(systemName: "person")!

        await sut.insert(image1, for: URL(string: "key1")!)
        await sut.insert(image2, for: URL(string: "key2")!)

        // When
        await sut.clear()

        // Then
        let retrievedImage1 = await sut.get(for: URL(string: "key1")!)
        let retrievedImage2 = await sut.get(for: URL(string: "key2")!)

        XCTAssertNil(retrievedImage1, "Image should be evicted")
        XCTAssertNil(retrievedImage2, "Image should be evicted")

        if let _ = retrievedImage1 {
            XCTFail("Image should have been evicted")
        }

        if let _ = retrievedImage2 {
            XCTFail("Image should have been evicted")
        }
    }

    func testConcurrentAccess_ShouldNotCrash() {
        // Given
        let expectation1 = expectation(description: "Thread 1 access")
        let expectation2 = expectation(description: "Thread 2 access")
        let key = URL(string: "concurrentKey")!

        // When
        DispatchQueue.global().async {
            Task {
                await self.sut.insert(UIImage(systemName: "star")!, for: key)
                expectation1.fulfill()
            }
        }

        DispatchQueue.global().async {
            Task {
                _ = await self.sut.get(for: key)
                expectation2.fulfill()
            }
        }

        // Then
        wait(for: [expectation1, expectation2], timeout: 5)
    }

    func testLargeImageCaching_ShouldStoreAndRetrieveSuccessfully() async {
        // Given
        var largeImage = UIImage(named: "LargeTestImage")!
        let key = URL(string: "largeImageKey")!

        // When
        await sut.insert(largeImage, for: key)
        largeImage = await sut.get(for: key)!

        // Then
        XCTAssertNotNil(largeImage, "Large image should be cached successfully")
    }
}

class MockRecipeRepository: RecipeRepository {
    var mockResult: [Recipe] = []
    var mockError: Error?

    func fetchRecipes() async throws -> [Recipe] {
        if let error = mockError {
            throw error
        }
        return mockResult
    }
}
