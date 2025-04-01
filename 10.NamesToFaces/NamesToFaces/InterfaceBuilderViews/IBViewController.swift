//
//  IBViewController.swift
//  NamesToFaces
//
//  Created by Виталий Овсянников on 28.03.2025.
//

import UIKit

class IBViewController: UICollectionViewController {

	private var dataSource: UICollectionViewDiffableDataSource<PersonSection, Person>!
	private let kPeople = "people"
	private var people: [Person] = [] {
		didSet {
			updateDataSource()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupDataSource()
		setupCollectionView()
		setupActions()

		loadPeople()
	}

	private func loadPeople() {
		guard
			let peopleData = UserDefaults.standard.data(forKey: kPeople),
			let	people = try? JSONDecoder().decode([Person].self, from: peopleData)
		else { return }

		self.people = people
	}

	private func setupCollectionView() {
		collectionView.contentInset = UIEdgeInsets(all: 16)
	}

	private func setupActions() {
		let addAction = UIAction(title: "Add new person", handler: addNewPerson)
		navigationItem.rightBarButtonItem = .init(systemItem: .add, primaryAction: addAction)
	}

	private func setupDataSource() {
		dataSource = .init(collectionView: collectionView) { collectionView, indexPath, person in
			let cell = collectionView.dequeue(reusable: IBPersonCollectionViewCell.self, for: indexPath)
			let imageURL = FileManager.default.documentsDirectory.appending(path: person.image)

			print(cell.intrinsicContentSize)
			cell.name = person.name
			cell.image = UIImage(contentsOfFile: imageURL.path)

			return cell
		}
	}

	private func updateDataSource() {
		var snapshot = dataSource.newSnapshot()
		snapshot.appendSections([.all])
		snapshot.appendItems(people, toSection: .all)

		dataSource.apply(snapshot, animatingDifferences: true)
	}

	private func save() {
		guard let savedData = try? JSONEncoder().encode(people)
		else { fatalError("Failed to encode people array") }

		UserDefaults.standard.set(savedData, forKey: kPeople)
	}

	// MARK: - Actions
	private func addNewPerson(with action: UIAction) {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self

		present(picker, animated: true)
	}
}

// MARK: - UICollectionViewDelegate
extension IBViewController {
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let alertController = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
		alertController.addTextField()

		let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
			guard
				let newName = alertController?.textFields?[0].text,
				var person = self?.people[indexPath.item]
			else { return }

			person.name = newName
			self?.people[indexPath.item] = person
			self?.save()
		}
		alertController.addAction(saveAction)

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		alertController.addAction(cancelAction)

		present(alertController, animated: true)
	}
}

// MARK: - UIImagePickerControllerDelegate
extension IBViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
	) {
		guard let image = info[.editedImage] as? UIImage else { return }

		let imageName = UUID().uuidString
		let imagePath = FileManager.default.documentsDirectory.appending(path: imageName)

		guard let jpegData = image.jpegData(compressionQuality: 0.8) else { return }
		try? jpegData.write(to: imagePath)

		let person = Person(name: "Unknown", image: imageName)
		people.append(person)
		save()

		picker.dismiss(animated: true)
	}
}
