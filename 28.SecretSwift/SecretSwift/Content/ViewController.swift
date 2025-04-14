//
//  ViewController.swift
//  SecretSwift
//
//  Created by Виталий Овсянников on 13.04.2025.
//

import Combine
import LocalAuthentication
import OSLog
import UIKit

class ViewController: UIViewController {

	@IBOutlet private var secret: UITextView!

	// MARK: Props
	private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "N/A", category: #function)

	private let secretTitle = "Nothing to see here…"
	private let unlockedTitle = "Secret stuff!"
	private let kSecret = "SecretMessage"
	private var cancellables: Set<AnyCancellable> = []
	private var isSecretLocked: Bool = true {
		didSet { updateNavigationBar() }
	}


	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		updateNavigationBar()
		setupSubscriptions()
	}


	// MARK: - Setup
	private func updateNavigationBar() {
		title = isSecretLocked ? secretTitle : unlockedTitle
		navigationItem.rightBarButtonItem?.image = UIImage(systemName: "lock\(isSecretLocked ? ".open" : ".fill")")
	}


	private func setupSubscriptions() {
		NotificationCenter.default
			.publisher(for: UIApplication.willResignActiveNotification)
			.sink { _ in self.saveSecretMessage() }
			.store(in: &cancellables)
	}


	// MARK: - Actions
	@IBAction func onAuthenticate(_ sender: UIBarButtonItem) {
		if isSecretLocked {
			unlockSecretMessage()
		} else {
			saveSecretMessage()
		}
	}


	private func unlockSecretMessage() {
		let context = LAContext()
		var error: NSError?

		guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
		else {
			logger.error("Cannot evaluate policy: \(error?.localizedDescription ?? "N/A")")
			return
		}

		Task {
			let reason = "Identify yourself!"
			do {
				try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)

				secret.text = KeychainWrapper.standard.string(forKey: kSecret) ?? ""
				secret.isHidden = false
				isSecretLocked = false
			} catch {
				logger.error("Error evaluating policy: \(error.localizedDescription)")
			}
		}
	}


	private func saveSecretMessage() {
		guard !isSecretLocked else { return }

		KeychainWrapper.standard.set(secret.text, forKey: kSecret)
		secret.resignFirstResponder()
		secret.isHidden = true
		isSecretLocked = true
		title = secretTitle
	}
}


// MARK: - Previews
#Preview {
	UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()!
}
