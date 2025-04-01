//
//  UIAlertController+extensions.swift
//  Instafilter
//
//  Created by Виталий Овсянников on 01.04.2025.
//

import UIKit

extension UIAlertController {
	func addActions(_ actions: UIAlertAction...) {
		actions.forEach(addAction)
	}

	func addActions(_ actions: [UIAlertAction]) {
		actions.forEach(addAction)
	}
}
