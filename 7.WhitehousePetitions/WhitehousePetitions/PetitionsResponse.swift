//
//  PetitionsResponse.swift
//  WhitehousePetitions
//
//  Created by Виталий Овсянников on 27.03.2025.
//

import Foundation

struct PetitionsResponse: Decodable {
	let results: [Petition]
}
