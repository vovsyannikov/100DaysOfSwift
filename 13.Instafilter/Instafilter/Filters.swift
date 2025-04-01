//
//  Filters.swift
//  Instafilter
//
//  Created by Виталий Овсянников on 01.04.2025.
//

import Foundation

enum Filters: String, CaseIterable {
	case bumpDistortion = "Bump Distortion"
	case gaussianBlur = "Gaussian Blur"
	case pixellate = "Pixellate"
	case sepiaTone = "Sepia Tone"
	case twirlDistortion = "Twirl Distortion"
	case unsharpMask = "Unsharp Mask"
	case vignette = "Vignette"

	var filterName: String {
		"CI\(rawValue.replacingOccurrences(of: " ", with: ""))"
	}
}
