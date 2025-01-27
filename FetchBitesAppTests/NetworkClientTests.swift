//
//  NetworkClientTests.swift
//  FetchBitesAppTests
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import XCTest
@testable import FetchBitesApp

final class NetworkClientTests: XCTestCase {

    var sut: NetworkClient!
    var mockURLSession: MockURLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockURLSession = MockURLSession()
        sut = NetworkClient(session: mockURLSession)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockURLSession = nil
        try super.tearDownWithError()
    }

    func test_fetchRecipes_shouldReturnValidData() async throws {
        // Given
        let expectedData = Data(
            """
                {"recipes": ["Recipe1", "Recipe2"]}
            """.utf8)
        mockURLSession.mockData = expectedData

        // When
        let result = try await sut.fetch(endpoint: .recipes)

        // Then
        XCTAssertEqual(result, expectedData, "The fetched data should match the expected data")
    }

    func test_fetchMalformedRecipes_shouldThrowDecodingError() async {
        // Given
        mockURLSession.mockData = Data("{\"name\":\"test\"}".utf8)  // Incompatible JSON structure

        // When
        do {
            let data = try await sut.fetch(endpoint: .malformedRecipes)
            let _ = try JSONDecoder().decode([Recipe].self, from: data)
            XCTFail("Expected decoding error but succeeded instead")
        } catch let decodingError as DecodingError {
            XCTAssertNotNil(decodingError, "Expected a DecodingError for malformed JSON")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func test_fetchEmptyRecipes_shouldReturnEmptyData() async throws {
        // Given
        mockURLSession.mockData = Data()

        // When
        let result = try await sut.fetch(endpoint: .emptyRecipes)

        // Then
        XCTAssertTrue(result.isEmpty, "Expected empty data response")
    }

    func test_fetchData_withNetworkError_shouldThrowError() async {
        // Given
        mockURLSession.mockError = URLError(.badServerResponse)

        // When
        do {
            _ = try await sut.fetch(endpoint: .recipes)
            XCTFail("Expected to throw a network error")
        } catch {
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse), "Expected bad server response error")
        }
    }
}

final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (mockData ?? Data(), response)
    }
}
