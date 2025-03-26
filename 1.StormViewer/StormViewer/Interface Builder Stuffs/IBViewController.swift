//
//  IBViewController.swift
//  StormViewer
//
//  Created by Виталий Овсянников on 26.03.2025.
//

import UIKit

final class IBViewController: UITableViewController {
	private var pictures = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()

		let fileManager = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fileManager.contentsOfDirectory(atPath: path)

		pictures = items.filter { $0.hasPrefix("nssl") }
	}
}

// MARK: - DataSource
extension IBViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		pictures.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		//		Deprecated method
		//		cell.textLabel?.text = pictures[indexPath.row]

		var cellConfig = UIListContentConfiguration.cell()
		cellConfig.text = pictures[indexPath.row]
		cell.contentConfiguration = cellConfig

		return cell
	}

}

// MARK: - Delegate
extension IBViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? IBDetailViewController
		else { return }

		vc.selectedImage = pictures[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}
}
