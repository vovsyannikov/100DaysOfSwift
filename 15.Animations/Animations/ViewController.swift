//
//  ViewController.swift
//  Animations
//
//  Created by Виталий Овсянников on 02.04.2025.
//

import UIKit

class ViewController: UIViewController {

	private var imageView: UIImageView!
	private var animationValue = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		createImageView()
	}

	private func createImageView() {
		imageView = UIImageView(image: .penguin)
		imageView.center = view.center

		view.addSubview(imageView)
	}


	@IBAction func animate(_ sender: UIButton) {
		sender.isEnabled = false

//		UIView.animate(
//			withDuration: 1,
//			delay: 0,
//			options: [],
		UIView.animate(
			withDuration: 1,
			delay: 0,
			usingSpringWithDamping: 0.5,
			initialSpringVelocity: 5,
			options: [],
			animations: {
				switch self.animationValue {
				case 0:self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
				case 1: self.imageView.transform = .identity
				case 2: self.imageView.transform = .init(translationX: -50, y: -100)
				case 3: self.imageView.transform = .identity
				case 4: self.imageView.transform = .init(rotationAngle: .pi)
				case 5: self.imageView.transform = .identity
				case 6:
					self.imageView.alpha = 0.5
					self.imageView.backgroundColor = .systemGreen
				case 7:
					self.imageView.alpha = 1
					self.imageView.backgroundColor = .clear
				default:
					break
				}
			},
			completion: { _ in
				sender.isEnabled = true
			}
		)

		animationValue += 1

		if animationValue > 7 {
			animationValue = 0
		}
	}
}

@available(iOS 17, *)
#Preview {
	UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
}
