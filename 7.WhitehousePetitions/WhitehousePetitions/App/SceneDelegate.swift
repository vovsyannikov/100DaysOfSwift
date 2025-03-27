//
//  SceneDelegate.swift
//  WhitehousePetitions
//
//  Created by Виталий Овсянников on 27.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func sceneDidBecomeActive(_ scene: UIScene) {
		guard let tabBarController = window?.rootViewController as? UITabBarController else { return }

		let storyboard = UIStoryboard(name: "Main", bundle: .main)
		let navController = storyboard.instantiateViewController(withIdentifier: "NavController")
		navController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
		tabBarController.viewControllers?.append(navController)
	}
}

