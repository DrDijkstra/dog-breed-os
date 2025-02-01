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

    func testScrollViewAndDataLoading() {
        // Wait for the ScrollView to exist
        let scrollView = app.scrollViews["dogBreedsScrollView"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "ScrollView should exist within 10 seconds")

        // Wait for the WaterfallGridView to load
        let waterfallGrid = app.otherElements["waterfallGridView"]
        XCTAssertTrue(waterfallGrid.waitForExistence(timeout: 10), "WaterfallGridView should load within 10 seconds")

        // Scroll down to load more data (if applicable)
        scrollView.swipeUp()
        scrollView.swipeUp()
    }

    func testCacheClearButton() {
        // Tap the cache clear button
        let cacheClearButton = app.buttons["cacheClearButton"]
        XCTAssertTrue(cacheClearButton.waitForExistence(timeout: 10), "Cache clear button should exist")
        cacheClearButton.tap()

        // Verify that the data is reloaded (you may need to add a visual indicator or state check)
    }

    func testDeleteButtonAndConfirmation() {
        // Tap the delete button
        let deleteButton = app.buttons["deleteButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 10), "Delete button should exist")
        deleteButton.tap()

        // Wait for the confirmation alert to appear
        let deleteConfirmationAlert = app.alerts["Delete All Breeds?"]
        XCTAssertTrue(deleteConfirmationAlert.waitForExistence(timeout: 5), "Delete confirmation alert should appear")

        // Tap "No" to dismiss the alert
        let noButton = app.buttons["deleteConfirmationNoButton"]
        noButton.tap()

        // Verify that the alert is dismissed
        XCTAssertFalse(deleteConfirmationAlert.exists, "Alert should be dismissed after tapping No")
    }

    func testDeleteButtonAndConfirmDeletion() {
        // Tap the delete button
        let deleteButton = app.buttons["deleteButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 10), "Delete button should exist")
        deleteButton.tap()

        // Wait for the confirmation alert to appear
        let deleteConfirmationAlert = app.alerts["Delete All Breeds?"]
        XCTAssertTrue(deleteConfirmationAlert.waitForExistence(timeout: 5), "Delete confirmation alert should appear")

        // Tap "Yes" to confirm deletion
        let yesButton = app.buttons["deleteConfirmationYesButton"]
        yesButton.tap()

        // Verify that the data is deleted (you may need to add a visual indicator or state check)
        // Wait for 5 seconds after deletion
        sleep(5)
    }
}
