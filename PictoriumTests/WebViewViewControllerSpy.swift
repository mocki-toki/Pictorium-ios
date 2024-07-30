//
//  WebViewViewControllerSpy.swift
//  Pictorium
//
//  Created by Simon Butenko on 30.07.2024.
//

import Foundation
@testable import Pictorium

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?

    var loadRequestCalled = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {}

    func setProgressHidden(_ isHidden: Bool) {}
}
