//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Виталий Овсянников on 13.04.2025.
//

import OSLog
import UIKit
import UserNotifications

class ViewController: UIViewController {

	let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: #function)


	private func registerCategories() {
		let unCenter = UNUserNotificationCenter.current()
		unCenter.delegate = self

		let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
		let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])

		unCenter.setNotificationCategories([category])
	}


	// MARK: - Actions
	@IBAction func registerTriggered(_ sender: Any) {
		let unCenter = UNUserNotificationCenter.current()

		Task {
			do {
				try await unCenter.requestAuthorization(options: [.alert, .badge, .sound])
				logger.log("Permissions granted")
			} catch {
				logger.error("Error: \(error)")
			}
		}
	}


	@IBAction func scheduleTriggered(_ sender: Any) {
		registerCategories()

		let unCenter = UNUserNotificationCenter.current()
		unCenter.removeAllPendingNotificationRequests()

		let content = UNMutableNotificationContent()
		content.title = "Late wake up call"
		content.body = "The early bird catches the worm, but the second mouse gets the cheese"
		content.categoryIdentifier = "alarm"
		content.userInfo = ["customData": "fizzbuzz"]
		content.sound = .default

#if DEBUG
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
#else
		let dateComponents = DateComponents(hour: 10, minute: 30)
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
#endif

		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

		Task {
			try? await unCenter.add(request)
			logger.log("Added notification")
		}
	}
}


// MARK: - UNUserNotificationCenterDelegate
extension ViewController: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
		let userInfo = response.notification.request.content.userInfo

		guard let customData = userInfo["customData"] as? String
		else { return }

		logger.log("Custom data received: \(customData)")

		switch response.actionIdentifier {
		case UNNotificationDefaultActionIdentifier:
			logger.info("Default action selected")

		case "show":
			logger.info("Show more info…")

		default:
			break
		}
	}
}
