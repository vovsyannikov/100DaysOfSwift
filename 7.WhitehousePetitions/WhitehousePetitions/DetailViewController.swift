//
//  DetailViewController.swift
//  WhitehousePetitions
//
//  Created by Виталий Овсянников on 27.03.2025.
//

import UIKit
import WebKit

final class DetailViewController: UIViewController {
	private let webView: WKWebView = {
		let webView = WKWebView()

		webView.translatesAutoresizingMaskIntoConstraints = false

		return webView
	}()

	var detailItem: Petition?

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
		setupWebView()

		guard let detailItem else { return }

		let detailHTML = """
			<html>
				<head>
					<meta name="viewport" content="width=device-width, initial-scale=1">
					<style> body { font-size: 150%; } </style>
				</head>
				<body>
					\(detailItem.body)
				</body>
			</html>
			"""

		webView.loadHTMLString(detailHTML, baseURL: nil)
	}

	private func setupWebView() {
		view.addSubview(webView)

		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

			webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
	}
}
