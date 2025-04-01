//
//  PersonDataSource.swift
//  NamesToFaces
//
//  Created by Виталий Овсянников on 28.03.2025.
//

import Foundation

enum PersonSection: Hashable {
	case all
}

struct Person: Hashable, Codable {
	var name: String
	var image: String
}
