//
//  PictoriumUITests.swift
//  Pictorium
//
//  Created by Simon Butenko on 31.07.2024.
//

import XCTest

final class PictoriumUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()

        let webView = app.webViews["UnsplashWebView"]

        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))

        loginTextField.tap()
        loginTextField.typeText("login")
        webView.swipeUp()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText("password")
        webView.swipeUp()

        webView.buttons["Login"].tap()

        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.waitForExistence(timeout: 10))
    }

    func testFeed() throws {
        sleep(2)
        let tablesQuery = app.tables

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()

        sleep(2)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 2)

        cellToLike.buttons["likeNoActive"].tap()
        sleep(5)
        cellToLike.buttons["likeActive"].tap()
        sleep(5)
        XCTAssertTrue(cellToLike.buttons["likeNoActive"].exists)

        cellToLike.tap()

        sleep(5)

        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButton = app.buttons["Nav back"]
        navBackButton.tap()
    }

    func testProfile() throws {
        sleep(10)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["First name Last name"].exists)
        XCTAssertTrue(app.staticTexts["Username"].exists)

        app.buttons["Logout button"].tap()

        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5))

        let confirmLogoutButton = alert.buttons["Да"]
        XCTAssertTrue(confirmLogoutButton.exists)
        confirmLogoutButton.tap()

        let loginButton = app.buttons["Войти"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
    }
}
