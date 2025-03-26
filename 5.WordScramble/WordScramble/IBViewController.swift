//
//  IBViewController.swift
//  WordScramble
//
//  Created by Виталий Овсянников on 26.03.2025.
//

import UIKit

class IBViewController: UITableViewController {
	private var allWords: [String] = []
	private var usedWords: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		loadGame()
		startGame()
	}

	private func loadGame() {
		let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt")!
		allWords = try! String(contentsOf: fileURL, encoding: .utf8).components(separatedBy: .newlines)
	}

	private func startGame() {
		title = allWords.randomElement()!
		usedWords.removeAll()
		tableView.reloadData()
	}

	// MARK: - Actions
	@IBAction
	func addActionTriggered(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)

		alertController.addTextField()

		let submitAction = UIAlertAction(title: "Submit", style: .default) {
			[weak self, weak alertController] _ in
			guard let answer = alertController?.textFields?[0].text else { return }

			self?.submit(answer)
		}

		alertController.addAction(submitAction)

		present(alertController, animated: true)
	}

	private func submit(_ answer: String) {
		do {
			let answer = answer.lowercased()

			try checkOriginality(answer)
			try checkPossibility(answer)
			try checkExistence(answer)

			usedWords.insert(answer, at: 0)

			let indexPath = IndexPath(row: 0, section: 0)
			tableView.insertRows(at: [indexPath], with: .automatic)
		} catch let wordError as WordError {
			showAlert(with: wordError)
		} catch {
			print("Something went wrong")
		}
	}

	// MARK: - Validation
	private func checkOriginality(_ answer: String) throws {
		if usedWords.contains(answer) {
			throw WordError.alreadyUsed
		}
	}

	private func checkPossibility(_ answer: String) throws {
		guard var temp = title?.lowercased()
		else { throw WordError.missingStartWord }

		for letter in answer {
			guard let position = temp.firstIndex(of: letter)
			else { throw WordError.impossible }

			temp.remove(at: position)
		}
	}

	private func checkExistence(_ answer: String) throws {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: answer.utf16.count)
		let misspelledRange = checker
			.rangeOfMisspelledWord(
				in: answer,
				range: range,
				startingAt: 0,
				wrap: false,
				language: "en"
			)

		if misspelledRange.location != NSNotFound {
			throw WordError.notReal
		}
	}

	private func showAlert(with error: WordError) {
		let alertController = UIAlertController(
			title: error.errorDescription,
			message: error.message,
			preferredStyle: .alert
		)

		alertController.addAction(UIAlertAction(title: "OK", style: .default))

		present(alertController, animated: true)
	}
}

// MARK: - DataSource
extension IBViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		usedWords.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)

		var config = UIListContentConfiguration.cell()
		config.text = usedWords[indexPath.row]

		cell.contentConfiguration = config

		return cell
	}
}
