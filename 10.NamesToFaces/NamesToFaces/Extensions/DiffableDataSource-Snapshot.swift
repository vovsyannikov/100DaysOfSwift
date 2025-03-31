//
//  DiffableDataSource-Snapshot.swift
//  NamesToFaces
//
//  Created by Виталий Овсянников on 28.03.2025.
//

import UIKit

extension UICollectionViewDiffableDataSource {
	func newSnapshot() -> NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
		.init()
	}
}
