//
//  IBViewController.swift
//  WhitehousePetitions
//
//  Created by Виталий Овсянников on 27.03.2025.
//

import UIKit

class IBViewController: UITableViewController {
	private var petitions = [Petition]()

	override func viewDidLoad() {
		super.viewDidLoad()

		loadData()
	}

	private func loadData() {
		// This is the only way to get petitions as the official website is now down
		let jsonVersion = (navigationController?.tabBarItem.tag ?? 0) + 1
		let urlString = "https://hackingwithswift.com/samples/petitions-\(jsonVersion).json"

		guard let url = URL(string: urlString)
		else { return }

		//			This is sketchy even for a tutorial so the implementation is replaced
		//			let data = try Data(contentsOf: url)
		Task {
			do {
				let (data, _) = try await URLSession.shared.data(from: url)
				let petitionResponse = try JSONDecoder().decode(PetitionsResponse.self, from: data)
				petitions = petitionResponse.results
				tableView.reloadData()
			} catch {
				print(error.localizedDescription)
				showError()
			}
		}
	}

	private func showError() {
		let alertController = UIAlertController(
			title: "Loading error",
			message: "There was a problem loading the feed; please check your connection and try again",
			preferredStyle: .alert
		)

		let dismissAction = UIAlertAction(title: "OK", style: .default)
		alertController.addAction(dismissAction)

		present(alertController, animated: true)
	}
}

// MARK: - DataSource
extension IBViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		petitions.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let petition = petitions[indexPath.row]

		var config = UIListContentConfiguration.subtitleCell()
		config.text = petition.title
		config.secondaryText = petition.body
		config.secondaryTextProperties.numberOfLines = 1

		cell.contentConfiguration = config

		return cell
	}
}

// MARK: - Delegate
extension IBViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailVC = DetailViewController()
		detailVC.detailItem = petitions[indexPath.row]

		navigationController?.pushViewController(detailVC, animated: true)
	}
}
