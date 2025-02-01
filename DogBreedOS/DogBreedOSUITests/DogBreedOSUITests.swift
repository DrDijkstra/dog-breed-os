//
//  DogBreedOSUITests.swift
//  DogBreedOSUITests
//
//  Created by Sanjay Dey on 2025-01-30.
//

import XCTest

final class DogBreedOSUITests: XCTestCase {

    // MARK: - Properties

    private var app: XCUIApplication!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Set up initial state, such as interface orientation, if needed.
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Tests

    @MainActor
    func testExample() throws {
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Example: XCTAssertTrue(app.staticTexts["Welcome"].exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        guard #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) else {
            return
        }

        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
}
