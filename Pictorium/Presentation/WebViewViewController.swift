//
//  WebViewViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 13.05.2024.
//

import UIKit
import WebKit

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    // MARK: - Private Properties

    private var estimatedProgressObservation: NSKeyValueObservation?

    // MARK: - Public Properties

    var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?

    // MARK: - IBOutlets

    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "UnsplashWebView"
        setupObservers()
        presenter?.viewDidLoad()
    }

    // MARK: - Private Methods

    private func setupObservers() {
        estimatedProgressObservation =
            webView.observe(\.estimatedProgress, options: []) { [weak self] _, _ in
                guard let self = self else { return }
                presenter?.didUpdateProgressValue(webView.estimatedProgress)
            }
    }

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    func load(request: URLRequest) {
        webView.load(request)
    }

    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: APIConfig.authURL) else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: APIConfig.accessKey),
            URLQueryItem(name: "redirect_uri", value: APIConfig.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: APIConfig.accessScope)
        ]

        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        presenter?.didUpdateProgressValue(0)
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    // MARK: - Private Methods

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
