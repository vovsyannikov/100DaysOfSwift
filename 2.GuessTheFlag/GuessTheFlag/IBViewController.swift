//
//  IBViewController.swift
//  GuessTheFlag
//
//  Created by Виталий Овсянников on 26.03.2025.
//

import UIKit

class IBViewController: UIViewController {
	@IBOutlet var topButton: UIButton!
	@IBOutlet var middleButton: UIButton!
	@IBOutlet var bottomButton: UIButton!

	private var buttons: [UIButton] {
		[topButton, middleButton, bottomButton]
	}

	private var countries = [String]()
	private var correctAnswer = 0
	private var score = 0

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		countries += [
			"estonia",
			"france",
			"germany",
			"ireland",
			"italy",
			"monaco",
			"nigeria",
			"poland",
			"russia",
			"spain",
			"uk",
			"us"
		]

		buttons.forEach {
			$0.layer.borderWidth = 1
			$0.layer.borderColor = UIColor.separator.cgColor
		}

		askQuestion()
	}

	private func askQuestion(with alertAction: UIAlertAction! = nil) {
		countries.shuffle()
		correctAnswer = Int.random(in: 0...2)

		title = countries[correctAnswer].uppercased()

		zip(buttons, countries[0...2])
			.forEach {
				$0.setImage(UIImage(named: $1), for: .normal)
			}
	}

	// MARK: - Actions
	@IBAction func flagActionTriggered(_ sender: UIButton) {
		let title: String

		if correctAnswer == sender.tag {
			title = "Correct"
			score += 1
		} else {
			title = "Wrong"
			score -= 1
		}

		let alertController = UIAlertController(title: title, message: "Your score: \(score)", preferredStyle: .alert)
		let continueAction = UIAlertAction(title: "Continue", style: .default, handler: askQuestion)

		alertController.addAction(continueAction)

		present(alertController, animated: true)
	}
}

