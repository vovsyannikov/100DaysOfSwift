//
//  UIEdgeInsets-Convenience.swift
//  NamesToFaces
//
//  Created by Виталий Овсянников on 28.03.2025.
//

import UIKit

extension UIEdgeInsets {
	init(all: CGFloat) {
		self.init(top: all, left: all, bottom: all, right: all)
	}

	init(topInset: CGFloat = 0, leftInset: CGFloat = 0, bottomInset: CGFloat = 0, rightInset: CGFloat = 0) {
		self.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
	}
}
