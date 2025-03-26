//
//  UIAlertController-Actions.swift
//  WebBrowser
//
//  Created by Виталий Овсянников on 26.03.2025.
//

import UIKit

extension UIAlertController {
	func addActions(_ actions: UIAlertAction...) {
		actions.forEach(addAction)
	}
}
