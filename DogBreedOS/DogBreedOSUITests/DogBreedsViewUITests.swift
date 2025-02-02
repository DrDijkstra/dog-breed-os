//
//  DogBreedsViewUITests.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-02-01.
//


import XCTest

final class DogBreedsViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Clean up after each test
    }

    // MARK: - Tests

    func testScrollViewAndDataLoading() {
        let scrollView = app.scrollViews["dogBreedsScrollView"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "ScrollView should exist within 10 seconds")

        let waterfallGrid = app.otherElements["waterfallGridView"]
        XCTAssertTrue(waterfallGrid.waitForExistence(timeout: 10), "WaterfallGridView should load within 10 seconds")

        // Simulate scrolling to load more data
        scrollView.swipeUp()
        scrollView.swipeUp()
    }

    func testCacheClearButton() {
        let cacheClearButton = app.buttons["cacheClearButton"]
        XCTAssertTrue(cacheClearButton.waitForExistence(timeout: 10), "Cache clear button should exist")
        cacheClearButton.tap()

        // Add assertions or checks to verify data reloading (if applicable)
    }

    func testDeleteButtonAndConfirmation() {
        let deleteButton = app.buttons["deleteButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 10), "Delete button should exist")
        deleteButton.tap()

        let deleteConfirmationAlert = app.alerts["Delete All Breeds?"]
        XCTAssertTrue(deleteConfirmationAlert.waitForExistence(timeout: 5), "Delete confirmation alert should appear")

        let noButton = app.buttons["deleteConfirmationNoButton"]
        noButton.tap()

        XCTAssertFalse(deleteConfirmationAlert.exists, "Alert should be dismissed after tapping No")
    }

    func testDeleteButtonAndConfirmDeletion() {
        let deleteButton = app.buttons["deleteButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 10), "Delete button should exist")
        deleteButton.tap()

        let deleteConfirmationAlert = app.alerts["Delete All Breeds?"]
        XCTAssertTrue(deleteConfirmationAlert.waitForExistence(timeout: 5), "Delete confirmation alert should appear")

        let yesButton = app.buttons["deleteConfirmationYesButton"]
        yesButton.tap()

        // Add assertions or checks to verify data deletion (if applicable)
        sleep(5) // Wait for deletion to complete
    }
}
