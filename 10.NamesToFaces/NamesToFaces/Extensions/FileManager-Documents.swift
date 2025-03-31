//
//  FileManager-Documents.swift
//  NamesToFaces
//
//  Created by Виталий Овсянников on 28.03.2025.
//

import Foundation

extension FileManager {
	var documentsDirectory: URL {
		urls(for: .documentDirectory, in: .userDomainMask)[0]
	}
}
