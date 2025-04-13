//
//  ViewController.swift
//  CapitalCities
//
//  Created by Виталий Овсянников on 03.04.2025.
//

import MapKit
import UIKit

class ViewController: UIViewController {

	@IBOutlet var mapView: MKMapView!

	override func viewDidLoad() {
		super.viewDidLoad()

		addAnnotations()
	}

	private func addAnnotations() {
		let capitals: [Capital] = [.london, .moscow, .paris, .rome, .washington]
		mapView.addAnnotations(capitals)
	}
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard annotation is Capital else { return nil }

		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Capital.reuseID)

		if annotationView == nil {
			annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Capital.reuseID)
			annotationView?.canShowCallout = true

			let button = UIButton(type: .detailDisclosure)
			annotationView?.rightCalloutAccessoryView = button
		} else {
			annotationView?.annotation = annotation
		}

		return annotationView
	}

	func mapView(
		_ mapView: MKMapView,
		annotationView view: MKAnnotationView,
		calloutAccessoryControlTapped control: UIControl
	) {
		guard let capital = view.annotation as? Capital else { return }

		let placeName = capital.title
		let placeInfo = capital.info

		let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
		ac.addAction(.init(title: "OK", style: .default))
		present(ac, animated: true)
	}
}
