//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Виталий Овсянников on 27.03.2025.
//

import UIKit

class ViewController: UIViewController {
	private let scoreLabel: UILabel = {
		let label = UILabel()

		label.textAlignment = .right
		label.text = "Score: 0"
		label.numberOfLines = 1
		label.font = .preferredFont(forTextStyle: .title2)

		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	private let cluesLabel: UILabel = {
		let label = UILabel()

		label.font = .preferredFont(forTextStyle: .title2)
		label.text = "CLUES"
		label.numberOfLines = 0

		label.setContentHuggingPriority(.init(1), for: .vertical)
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()
	private let answersLabel: UILabel = {
		let label = UILabel()

		label.font = .preferredFont(forTextStyle: .title2)
		label.text = "ANSWERS"
		label.numberOfLines = 0
		label.textAlignment = .right

		label.setContentHuggingPriority(.init(1), for: .vertical)
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	private let currentAnswer: UITextField = {
		let textField = UITextField()

		textField.placeholder = "Tap letters to guess"
		textField.textAlignment = .center
		textField.font = .preferredFont(forTextStyle: .largeTitle)
		textField.isUserInteractionEnabled = false

		textField.translatesAutoresizingMaskIntoConstraints = false

		return textField
	}()

	private let actionButtonsStack: UIStackView = {
		let stackView = UIStackView()

		stackView.axis = .horizontal
		stackView.spacing = 100

		stackView.translatesAutoresizingMaskIntoConstraints = false

		return stackView
	}()
	private let submitButton: UIButton = {
		let button = UIButton(type: .system)

		button.setTitle("SUBMIT", for: .normal)

		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}()
	private let clearButton: UIButton = {
		let button = UIButton(type: .system)

		button.setTitle("CLEAR", for: .normal)

		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}()

	private let buttonsView: UIView = {
		let view = UIView()

		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()
	private var letterButtons = [UIButton]()
	private var selectedButtons: [UIButton] {
		letterButtons.filter(\.isSelected)
	}

	private var solutions = [String]()
	private var level = 1
	private var score: Int = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}

	// MARK: - Lifecycle
	override func loadView() {
		view = UIView()
		view.backgroundColor = .systemBackground

		setupViews()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupActions()
		loadLevel()
	}

	private func setupViews() {
		view.addSubview(scoreLabel)
		view.addSubview(cluesLabel)
		view.addSubview(answersLabel)
		view.addSubview(currentAnswer)
		view.addSubview(actionButtonsStack)
		actionButtonsStack.addArrangedSubview(submitButton)
		actionButtonsStack.addArrangedSubview(clearButton)
		view.addSubview(buttonsView)

		NSLayoutConstraint.activate(
			[
				scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
				scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
				
				cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
				cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
				cluesLabel.widthAnchor.constraint(
					equalTo: view.layoutMarginsGuide.widthAnchor,
					multiplier: 0.6,
					constant: -100
				),
				
				answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
				answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
				answersLabel.widthAnchor.constraint(
					equalTo: view.layoutMarginsGuide.widthAnchor,
					multiplier: 0.4,
					constant: -100
				),
				answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),

				currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
				currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
				currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor),

				actionButtonsStack.heightAnchor.constraint(equalToConstant: 44),
				actionButtonsStack.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
				actionButtonsStack.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),

				buttonsView.widthAnchor.constraint(equalToConstant: 750),
				buttonsView.heightAnchor.constraint(equalToConstant: 320),
				buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				buttonsView.topAnchor.constraint(equalTo: actionButtonsStack.bottomAnchor, constant: 20),
				buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
			]
		)

		setupLetterButtons()
	}

	private func setupLetterButtons() {
		let width = 150
		let height = 80

		for row in 0..<4 {
			for col in 0..<5 {
				var buttonConfig = UIButton.Configuration.plain()
				buttonConfig.title = "WWW"

				let letterButton = UIButton(configuration: buttonConfig)
				letterButton.titleLabel?.font = .preferredFont(forTextStyle: .title1)

				let action = UIAction(title: "Letter tapped") { _ in
					self.letterActionTriggered(letterButton)
				}
				letterButton.addAction(action, for: .primaryActionTriggered)

				let frame = CGRect(
					x: col * width,
					y: row * height,
					width: width,
					height: height
				)
				letterButton.frame = frame

				buttonsView.addSubview(letterButton)
				letterButtons.append(letterButton)
			}
		}
	}

	private func setupActions() {
		submitButton.addAction(
			UIAction(title: "Submit answer", handler: submitActionTriggered),
			for: .primaryActionTriggered
		)

		clearButton.addAction(
			UIAction(title: "Clear answer", handler: clearActionTriggered),
			for: .primaryActionTriggered
		)
	}

	private func letterActionTriggered(_ sender: UIButton) {
		guard let title = sender.titleLabel?.text else { return }
		sender.isSelected.toggle()

		updateCurrentAnswer(for: title, isSelected: sender.isSelected)
	}

	private func updateCurrentAnswer(for title: String, isSelected: Bool) {
		if isSelected {
			currentAnswer.text?.append(title)
		} else {
			currentAnswer.text = currentAnswer.text?.replacingOccurrences(of: title, with: "")
		}
	}

	private func submitActionTriggered(_ action: UIAction) {
		guard
			let answerText = currentAnswer.text,
			let solutionPosition = solutions.firstIndex(of: answerText)
		else { return }

		var splitAnswers = answersLabel.text?.components(separatedBy: .newlines)
		splitAnswers?[solutionPosition] = answerText

		answersLabel.text = splitAnswers?.joined(separator: "\n")
		currentAnswer.text = ""
		score += 1

		selectedButtons.forEach { $0.isEnabled = false }

		guard score == 7 else { return }
		showEndGameAlert()
	}

	private func showEndGameAlert() {
		let alertController = UIAlertController(
			title: "Well done!",
			message: "Are you ready for the next level?",
			preferredStyle: .alert
		)

		alertController.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))

		present(alertController, animated: true)
	}

	private func levelUp(action: UIAlertAction) {
		level += 1
		solutions.removeAll(keepingCapacity: true)
		loadLevel()

		letterButtons.forEach {
			$0.isSelected = false
			$0.isEnabled = true
		}
	}

	private func clearActionTriggered(_ action: UIAction) {
		letterButtons.forEach {
			if $0.isEnabled {
				$0.isSelected = false
			}
		}
		currentAnswer.text = ""
	}

	private func loadLevel() {
		var clueString = ""
		var solutionsString = ""
		var letterBits = [String]()

		guard let fileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"),
			  let levelContents = try? String(contentsOf: fileURL, encoding: .utf8)
		else { return }

		let lines = levelContents.components(separatedBy: .newlines).shuffled()

		for (index, line) in lines.enumerated() {
			let parts = line.components(separatedBy: ": ")
			let answer = parts[0]
			let clue = parts[1]

			clueString += "\(index + 1). \(clue)\n"

			let solutionWord = answer.replacingOccurrences(of: "|", with: "")
			solutionsString += "\(solutionWord.count) letters\n"
			solutions.append(solutionWord)

			let bits = answer.components(separatedBy: "|")
			letterBits += bits
		}

		cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
		answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)

		letterButtons.shuffle()

		if letterButtons.count == letterBits.count {
			for i in 0..<letterButtons.count {
				var attributedTitle = AttributedString(letterBits[i])
				attributedTitle.font = .preferredFont(forTextStyle: .title1)

				letterButtons[i].configuration?.attributedTitle = attributedTitle
			}
		}
	}
}

#Preview {
	ViewController()
}
