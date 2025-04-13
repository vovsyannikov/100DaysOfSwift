//
//  Capital.swift
//  CapitalCities
//
//  Created by Виталий Овсянников on 03.04.2025.
//

import MapKit

final class Capital: NSObject, MKAnnotation {
	static let reuseID = "Capital"

	var title: String?
	var coordinate: CLLocationCoordinate2D
	var info: String

	init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String) {
		self.title = title
		self.coordinate = coordinate
		self.info = info
	}
}

// MARK: - Examples
extension Capital {
	static let london: Capital = Capital(
		title: "London",
		coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
		info: "Home of the 2012 Summer Olympics."
	)

	static let moscow = Capital(
		title: "Moscow",
		coordinate: CLLocationCoordinate2D(latitude: 55.753, longitude: 37.62),
		info: "There's a dead guy in the middle."
	)

	static let paris: Capital = Capital(
		title: "Paris",
		coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508),
		info: "Often called The City of Love."
	)

	static let rome = Capital(
		title: "Rome",
		coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
		info: "Has a whole country inside (Vatican)."
	)

	static let washington = Capital(
		title: "Washington D.C.",
		coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667),
		info: "Named after some George."
	)
}
