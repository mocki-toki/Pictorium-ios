//
//  WebViewPresenterSpy.swift
//  Pictorium
//
//  Created by Simon Butenko on 30.07.2024.
//

import Foundation
@testable import Pictorium

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {}

    func code(from url: URL) -> String? {
        return nil
    }
}
