//
//  IBViewController.swift
//  Instafilter
//
//  Created by Виталий Овсянников on 01.04.2025.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

class IBViewController: UIViewController {
	
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var intensitySlider: UISlider!
	@IBOutlet var saveBarItem: UIBarButtonItem!

	private var currentImage: UIImage! {
		didSet {
			saveBarItem.isEnabled = currentImage != nil
		}
	}
	private var context: CIContext!
	private var currentFilter: CIFilter!

	override func viewDidLoad() {
		super.viewDidLoad()

		context = .init()
		currentFilter = CIFilter.sepiaTone()
	}

	// MARK: - Actions
	@IBAction func importPicture(_ sender: UIBarButtonItem) {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self

		present(picker, animated: true)
	}

	@IBAction func intensityChanged(_ sender: UISlider) {
		applyProcessing()
	}

	private func applyProcessing() {
		let intensity = intensitySlider.value
		let inputKeys = currentFilter.inputKeys

		if inputKeys.contains(kCIInputIntensityKey) {
			currentFilter.setValue(intensity, forKey: kCIInputIntensityKey)
		}
		if inputKeys.contains(kCIInputRadiusKey) {
			currentFilter.setValue(intensity * 400, forKey: kCIInputRadiusKey)
		}
		if inputKeys.contains(kCIInputScaleKey) {
			currentFilter.setValue(intensity * 10, forKey: kCIInputScaleKey)
		}
		if inputKeys.contains(kCIInputCenterKey) {
			currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2),
								   forKey: kCIInputCenterKey)
		}

		guard let outputImage = currentFilter.outputImage else { return }
		guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
		else { return }

		let processedImage = UIImage(cgImage: cgImage)
		imageView.image = processedImage
	}

	@IBAction func changeFilterTriggered(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)

		Filters.allCases.forEach { filter in
			let filterAction = UIAlertAction(title: filter.rawValue, style: .default, handler: setFilter)
			alertController.addAction(filterAction)
		}

		alertController.addAction(.cancel())

		if let popoverPresentationController = alertController.popoverPresentationController {
			popoverPresentationController.sourceItem = sender
		}

		present(alertController, animated: true)
	}

	private func setFilter(from action: UIAlertAction) {
		guard
			currentImage != nil,
			let filterTitle = action.title,
			let filter = Filters(rawValue: filterTitle)
		else { return }

		currentFilter = CIFilter(name: filter.filterName)
		setupFilter()
	}

	private func setupFilter() {
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		applyProcessing()
	}

	@IBAction func saveTriggered(_ sender: UIBarButtonItem) {
		guard let image = imageView.image else { return }

		UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
	}

	@objc
	private func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		let alertController = if let error {
			UIAlertController(
				title: "Save error",
				message: error.localizedDescription,
				preferredStyle: .alert
			)
		} else {
			UIAlertController(
				title: "Saved!",
				message: "Your altered image was saved to your photos.",
				preferredStyle: .alert
			)
		}

		alertController.addAction(.ok())

		present(alertController, animated: true)
	}
}

// MARK: - UIImagePicker Delegate
extension IBViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
	) {
		guard let image = info[.editedImage] as? UIImage else { return }
		picker.dismiss(animated: true)

		currentImage = image
		setupFilter()
	}
}

