//
//  ProfilePresenterSpy.swift
//  Pictorium
//
//  Created by Simon Butenko on 31.07.2024.
//

@testable import Pictorium

class ProfilePresenterSpy: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var didTapExitButtonCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didTapExitButton() {
        didTapExitButtonCalled = true
    }
}
