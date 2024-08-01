//
//  ImagesListViewControllerTests.swift
//  Pictorium
//
//  Created by Simon Butenko on 31.07.2024.
//

@testable import Pictorium
import XCTest

class ImagesListViewControllerTests: XCTestCase {
    var sut: ImagesListViewController!
    var presenterSpy: ImagesListPresenterSpy!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController") as? ImagesListViewController
        presenterSpy = ImagesListPresenterSpy()
        sut.presenter = presenterSpy as! any ImagesListPresenterProtocol
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

    func testHideShimmer() {
        sut.hideShimmerEffect()
        XCTAssertTrue(sut.shimmerContainerView.isHidden)
        XCTAssertFalse(sut.tableView.isHidden)
    }

    func testTableViewDelegateSet() {
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertTrue(sut.tableView.delegate is ImagesListViewController)
    }

    func testTableViewDataSourceSet() {
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertTrue(sut.tableView.dataSource is ImagesListViewController)
    }

    func testNumberOfRowsInSection() {
        let expectedCount = 5
        presenterSpy.photos = Array(repeating: Photo.mock(), count: expectedCount)

        let actualCount = sut.tableView(sut.tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(actualCount, expectedCount)
    }

    func testWillDisplayCellCallsFetchNextPage() {
        let indexPath = IndexPath(row: 9, section: 0)
        presenterSpy.photos = Array(repeating: Photo.mock(), count: 10)

        sut.tableView(sut.tableView, willDisplay: UITableViewCell(), forRowAt: indexPath)

        XCTAssertTrue(presenterSpy.fetchPhotosNextPageCalled)
    }
}

extension Photo {
    static func mock() -> Photo {
        return Photo(
            id: "1",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: "Test photo",
            thumbImageURL: URL(string: "https://example.com/thumb.jpg")!,
            largeImageURL: URL(string: "https://example.com/large.jpg")!,
            isLiked: false)
    }
}
