//
//  ProfileViewControllerTests.swift
//  Pictorium
//
//  Created by Simon Butenko on 31.07.2024.
//

@testable import Pictorium
import XCTest

class ProfileViewControllerTests: XCTestCase {
    var sut: ProfileViewController!
    var presenterSpy: ProfilePresenterSpy!

    override func setUp() {
        super.setUp()
        sut = ProfileViewController()
        presenterSpy = ProfilePresenterSpy()
        sut.presenter = presenterSpy
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        presenterSpy = nil
        super.tearDown()
    }

    func testViewDidLoadCallsPresenter() {
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }

    func testUpdateProfileDetails() {
        let profile = Profile(username: "test", name: "Test User", loginName: "@test", bio: "Test bio")
        sut.updateProfileDetails(profile: profile)

        XCTAssertEqual(sut.nameLabel.text, "Test User")
        XCTAssertEqual(sut.usernameLabel.text, "@test")
        XCTAssertEqual(sut.descriptionLabel.text, "Test bio")
    }

    func testExitButtonTapped() {
        sut.exitButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(presenterSpy.didTapExitButtonCalled)
    }
}
