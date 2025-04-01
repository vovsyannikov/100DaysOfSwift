//
//  UserDefaults-Generic.swift
//  NamesToFaces
//
//  Created by Виталий Овсянников on 01.04.2025.
//

import Foundation

extension UserDefaults {
	func value<T>(forKey key: String) -> T? {
		value(forKey: key) as? T
	}

}
