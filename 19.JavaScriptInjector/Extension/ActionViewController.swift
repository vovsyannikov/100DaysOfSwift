//
//  ActionViewController.swift
//  Extension
//
//  Created by Виталий Овсянников on 13.04.2025.
//

import Combine
import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

	@IBOutlet var scriptTextView: UITextView!
	private var pageTitle = ""
	private var pageURL = ""
	private var cancellables: Set<AnyCancellable> = []


	override func viewDidLoad() {
		super.viewDidLoad()

		fetchItems()
//		registerNotifications()
	}


	private func fetchItems() {
		guard let inputItem = extensionContext?.inputItems.first as? NSExtensionItem,
			  let itemProvider = inputItem.attachments?.first
		else { return }

		Task {
			do {
				let dict = try await itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier)

				guard let itemDictionary = dict as? NSDictionary,
					  let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary
				else { return }

				pageTitle = javaScriptValues["title"] as? String ?? ""
				pageURL = javaScriptValues["URL"] as? String ?? ""
				title = pageTitle
			} catch {
				print("Error loading item: \(error)")
			}
		}
	}


	@available(iOS, introduced: 2, deprecated: 15, message: "Use some container view pinned to keyboardLayoutGuide.topAnchor instead")
	private func registerNotifications() {
		let center = NotificationCenter.default

		center
			.publisher(for: UIResponder.keyboardWillHideNotification)
			.sink(receiveValue: adjustForKeyboard)
			.store(in: &cancellables)

		center
			.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
			.sink(receiveValue: adjustForKeyboard)
			.store(in: &cancellables)
	}


	private func adjustForKeyboard(with notification: Notification) {
		guard
			let userInfo = notification.userInfo,
			let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
		else { return }

		let keyboardFrame = keyboardFrameValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardFrame, from: view.window)

		if notification.name == UIResponder.keyboardWillHideNotification {
			scriptTextView.contentInset = .zero
		} else {
			scriptTextView.contentInset = .init(
				top: 0,
				left: 0,
				bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
				right: 0
			)
			scriptTextView.scrollIndicatorInsets = scriptTextView.contentInset
			scriptTextView.scrollRangeToVisible(scriptTextView.selectedRange)
		}
	}


    @IBAction func done() {
		let item = NSExtensionItem()
		let argument: NSDictionary = ["customJavaScript": scriptTextView.text as Any]
		let webDict: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
		let customJavaScript = NSItemProvider(item: webDict, typeIdentifier: UTType.propertyList.identifier)
		item.attachments = [customJavaScript]

		extensionContext?.completeRequest(returningItems: [item])
    }
}
