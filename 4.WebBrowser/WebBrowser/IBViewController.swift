//
//  IBViewController.swift
//  WebBrowser
//
//  Created by Виталий Овсянников on 26.03.2025.
//

import Combine
import UIKit
import WebKit

final class IBViewController: UIViewController {
	private lazy var webView: WKWebView = {
		let webView = WKWebView()

		webView.navigationDelegate = self
		webView.allowsBackForwardNavigationGestures = true

		webView.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(webView)

		return webView
	}()
	private lazy var progressView: UIProgressView = {
		let progressView = UIProgressView(progressViewStyle: .default)

		progressView.sizeToFit()

		return progressView
	}()
	private var websites = ["apple.com", "hackingwithswift.com"]

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		addConstraints()
		setupWebView()
		setupToolbarItems()
	}

	private func addConstraints() {
		NSLayoutConstraint.activate([
			webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	private func setupWebView() {
		let url = URL(string: "https://" + websites[0])!
		webView.loadRequest(from: url)

//		KVO approach
//		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

//		Combine Approach
		webView
			.publisher(for: \.estimatedProgress, options: .new)
			.map(Float.init)
			.assign(to: \.progressView.progress, on: self)
			.store(in: &cancellables)
	}

	private func setupToolbarItems() {
		let progressItem = UIBarButtonItem(customView: progressView)
		toolbarItems?.insert(progressItem, at: 0)
	}

//	KVO observation
//	override func observeValue(
//		forKeyPath keyPath: String?,
//		of object: Any?,
//		change: [NSKeyValueChangeKey : Any]?,
//		context: UnsafeMutableRawPointer?
//	) {
//		if keyPath == #keyPath(WKWebView.estimatedProgress) {
//			progressView.progress = Float(webView.estimatedProgress)
//		}
//	}

	// MARK: - Actions
	@IBAction func openActionTriggered(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)

		websites.forEach {
			let action = UIAlertAction(
				title: $0,
				style: .default,
				handler: openPage
			)

			alertController.addAction(action)
		}

		let cancelAction = UIAlertAction(
			title: "Cancel",
			style: .cancel
		)

		alertController.addAction(cancelAction)

		alertController.popoverPresentationController?.barButtonItem = sender

		present(alertController, animated: true)
	}

	private func openPage(for alertAction: UIAlertAction) {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = alertAction.title

		guard let url = urlComponents.url else { return }

		webView.loadRequest(from: url)
	}

	@IBAction func refreshActionTriggered(_ sender: UIBarButtonItem) {
		webView.reload()
	}
}

// MARK: - WKNavigationDelegate
extension IBViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}

//	Completion Handler Approach
//	func webView(
//		_ webView: WKWebView,
//		decidePolicyFor navigationAction: WKNavigationAction,
//		decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
//	) {
//		let url = navigationAction.request.url
//		let policy: WKNavigationActionPolicy
//
//		defer { decisionHandler(policy) }
//
//		if let host = url?.host() {
//			for website in websites {
//				if host.contains(website) {
//					policy = .allow
//					return
//				}
//			}
//		}
//
//		policy = .cancel
//	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
		guard let host = navigationAction.request.url?.host() else { return .cancel }

		let isAllowedWebsite = websites.contains { site in host.contains(site) }

		return isAllowedWebsite ? .allow : .cancel
	}
}
