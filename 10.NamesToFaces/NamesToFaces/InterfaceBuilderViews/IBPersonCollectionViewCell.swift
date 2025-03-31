//
//  IBPersonCollectionViewCell.swift
//  NamesToFaces
//
//  Created by Виталий Овсянников on 28.03.2025.
//

import UIKit

final class IBPersonCollectionViewCell: UICollectionViewCell, IdentifiableCell {
	static var identifier = "Person"

	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var nameLabel: UILabel!

	var image: UIImage? {
		get { imageView.image }
		set { imageView.image = newValue }
	}

	var name: String {
		get { nameLabel.text ?? "" }
		set { nameLabel.text = newValue }
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		imageView.layer.borderWidth = 2
		imageView.layer.borderColor = UIColor.separator.cgColor
		imageView.layer.cornerRadius = 3
	}
}
