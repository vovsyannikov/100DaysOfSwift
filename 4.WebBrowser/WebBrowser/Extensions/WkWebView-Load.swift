//
//  WkWebView-Load.swift
//  WebBrowser
//
//  Created by Виталий Овсянников on 26.03.2025.
//

import WebKit

extension WKWebView {
	func loadRequest(from url: URL) {
		load(URLRequest(url: url))
	}
}
