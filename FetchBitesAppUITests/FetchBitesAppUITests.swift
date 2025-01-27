//
//  FetchBitesAppUITests.swift
//  FetchBitesAppUITests
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import XCTest

final class FetchBitesUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testRecipeListDisplay() throws {
        // Wait for recipes to load
        let firstRecipe = app.buttons["View Recipe"].firstMatch
        XCTAssertTrue(firstRecipe.waitForExistence(timeout: 5))

        // Check for basic UI elements
        XCTAssertTrue(app.navigationBars["FetchBites"].exists)
        XCTAssertTrue(app.buttons["View Recipe"].firstMatch.exists)
        XCTAssertTrue(app.buttons["Watch Video"].firstMatch.exists)
    }

    func testRecipeImageTap() throws {
        // Wait for content to load
        let image = app.images.firstMatch
        XCTAssertTrue(image.waitForExistence(timeout: 5))

        // Tap image
        image.tap()

        // Verify preview appears
        let closeButton = app.buttons["Close"].firstMatch
        XCTAssertTrue(closeButton.waitForExistence(timeout: 2))

        // Dismiss preview
        closeButton.tap()
    }

    func testPullToRefresh() throws {
        // Change to scrollView
        let scrollView = app.scrollViews.firstMatch

        let start = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let end = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 1.0))
        start.press(forDuration: 0.1, thenDragTo: end)

        let recipe = app.buttons["View Recipe"].firstMatch
        XCTAssertTrue(recipe.waitForExistence(timeout: 5))
    }

    func testSortingToggle() throws {
        app.buttons["Alphabetical"].tap()
        app.buttons["By Cuisine"].tap()

        // Check if any cuisine text exists
        let exists = app.staticTexts["American"].exists ||
        app.staticTexts["British"].exists ||
        app.staticTexts["Malaysian"].exists
        XCTAssertTrue(exists)
    }

    func testMalformedDataEndpoint() throws {
        let app = XCUIApplication()
        app.launchEnvironment["USE_ENDPOINT"] = "malformed"
        app.launch()

        // Verify initial error state
        let errorText = app.staticTexts["Something went wrong"]
        XCTAssertTrue(errorText.waitForExistence(timeout: 5))

        // Tap retry and verify we see error state again (since endpoint is still malformed)
        let tryAgainButton = app.buttons["Try Again"]
        XCTAssertTrue(tryAgainButton.exists)
        tryAgainButton.tap()

        // Error should reappear
        XCTAssertTrue(errorText.waitForExistence(timeout: 5))
    }

    func testEmptyDataEndpoint() throws {
        let app = XCUIApplication()
        app.launchEnvironment["USE_ENDPOINT"] = "empty"
        app.launch()

        // Verify empty state appears
        let emptyImage = app.images["fork.knife.circle"]
        XCTAssertTrue(emptyImage.waitForExistence(timeout: 5))

        let emptyText = app.staticTexts["No Recipes Found"]
        XCTAssertTrue(emptyText.exists)
    }

    func testVideoPlayerDismissal() {
        let app = XCUIApplication()
        app.launch()

        // Wait for and tap video button
        let videoButton = app.buttons["Watch Video"].firstMatch
        XCTAssertTrue(videoButton.waitForExistence(timeout: 5))
        videoButton.tap()

        // Verify and tap dismiss button
        let dismissButton = app.buttons["xmark.circle.fill"].firstMatch
        XCTAssertTrue(dismissButton.waitForExistence(timeout: 2))
        dismissButton.tap()
    }
}
