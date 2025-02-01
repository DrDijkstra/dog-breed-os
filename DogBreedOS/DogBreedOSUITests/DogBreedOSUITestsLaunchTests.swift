//
//  DogBreedOSUITestsLaunchTests.swift
//  DogBreedOSUITests
//
//  Created by Sanjay Dey on 2025-01-30.
//

import XCTest

final class DogBreedOSUITestsLaunchTests: XCTestCase {

    // MARK: - Properties

    private var app: XCUIApplication!

    // MARK: - Lifecycle

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        return true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    // MARK: - Tests

    @MainActor
    func testLaunch() throws {
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app.

        captureScreenshot(named: "Launch Screen")
    }

    // MARK: - Helper Methods

    private func captureScreenshot(named name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
