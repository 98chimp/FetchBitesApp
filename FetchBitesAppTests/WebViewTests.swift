//
//  WebViewTests.swift
//  FetchBitesAppTests
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

@testable import FetchBitesApp
import XCTest

final class WebViewTests: XCTestCase {
    func testWebViewInitialization() {
        let webView = WebView(urlString: "https://example.com")
        XCTAssertNotNil(webView)
    }
}

final class VideoPlayerViewTests: XCTestCase {
    func testYouTubeURLTransformation() {
        let originalURL = URL(string: "https://youtube.com/watch?v=12345")!
        let transformedURL = originalURL.absoluteString.replacingOccurrences(
            of: "youtube.com/watch?v=",
            with: "youtube.com/embed/"
        )
        XCTAssertEqual(transformedURL, "https://youtube.com/embed/12345")
    }
}

final class RecipeCardViewTests: XCTestCase {
    let imageCache = ImageCache()

    func testRecipeCardView_BasicElements() {
        let recipe = Recipe.preview
        let view = RecipeCardView(
            recipe: recipe,
            onTapImage: { _ in },
            onTapVideo: { _ in },
            onTapSource: { _ in },
            imageCache: imageCache
        )

        XCTAssertNotNil(view)
    }

    func testRecipeCardView_OptionalElements() {
        // Test without video URL
        let recipeNoVideo = Recipe.previewNoVideo
        let view = RecipeCardView(
            recipe: recipeNoVideo,
            onTapImage: { _ in },
            onTapVideo: { _ in },
            onTapSource: { _ in },
            imageCache: imageCache
        )

        XCTAssertNotNil(view)
    }
}
