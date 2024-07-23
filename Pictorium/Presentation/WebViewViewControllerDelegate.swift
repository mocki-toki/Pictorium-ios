//
//  WebViewViewControllerDelegate.swift
//  Pictorium
//
//  Created by Simon Butenko on 21.05.2024.
//

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ viewController: WebViewViewController)
}
