//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Виталий Овсянников on 27.03.2025.
//

import Foundation

struct Petition: Identifiable, Decodable {
	let id: String

	let title: String
	let body: String
	let signatureCount: Int
	let signatureThreshold: Int
}
