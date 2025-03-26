//
//  WordError.swift
//  WordScramble
//
//  Created by Виталий Овсянников on 26.03.2025.
//

import Foundation

enum WordError: LocalizedError {
	case alreadyUsed
	case impossible
	case notReal

	case missingStartWord

	var errorDescription: String? {
		switch self {
		case .alreadyUsed:
			"Word already used"
		case .impossible:
			"Word not possible"
		case .notReal:
			"Word not recognized"
		case .missingStartWord:
			"Start word is missing"
		}
	}

	var message: String? {
		switch self {
		case .alreadyUsed:
			"Be more original"
		case .impossible:
			"You can't spell that word from prompt"
		case .notReal:
			"You can't just make them up you know"

		case .missingStartWord:
			"There's something wrong with start word"
//		case .alreadyUsed, .impossible, .notReal, .missingStartWord:
//			return nil
		}
	}
}
