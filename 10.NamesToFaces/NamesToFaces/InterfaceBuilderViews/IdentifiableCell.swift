//
//  IdentifiableCell.swift
//  NamesToFaces
//
//  Created by Виталий Овсянников on 28.03.2025.
//

import UIKit

protocol IdentifiableCell {
	static var identifier: String { get }
}

extension UICollectionView {
	func dequeue<Cell: IdentifiableCell>(reusable cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
		dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
	}
}

extension UITableView {
	func dequeue<Cell: IdentifiableCell>(reusable cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
		dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
	}
}
