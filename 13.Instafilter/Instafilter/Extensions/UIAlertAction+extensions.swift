//
//  UIAlertAction+extensions.swift
//  Instafilter
//
//  Created by Виталий Овсянников on 01.04.2025.
//

import UIKit

extension UIAlertAction {
	static func ok(_ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		UIAlertAction(title: "OK", style: .default, handler: handler)
	}
	static func cancel(_ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		UIAlertAction(title: "Cancel", style: .cancel, handler: handler)
	}
}
