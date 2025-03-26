//
//  IBDetailViewController.swift
//  StormViewer
//
//  Created by Виталий Овсянников on 26.03.2025.
//

import UIKit

final class IBDetailViewController: UIViewController {
	@IBOutlet private var imageView: UIImageView!

	var selectedImage: String?

	override func viewDidLoad() {
		super.viewDidLoad()

		title = selectedImage

		guard let selectedImage else { return }

		imageView.image = UIImage(named: selectedImage)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.hidesBarsOnTap = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		navigationController?.hidesBarsOnTap = false
	}
}
