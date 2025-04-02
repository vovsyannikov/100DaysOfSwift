//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Виталий Овсянников on 02.04.2025.
//

import SpriteKit
import UIKit

final class WhackSlot: SKNode {
	private(set) var charNode: SKSpriteNode!

	private(set) var isVisible = false
	private(set) var isHit = false

	private let hiddenOffset: CGFloat = 90

	var charNodeScale: CGFloat = 1 {
		didSet {
			charNode.xScale = charNodeScale
			charNode.yScale = charNodeScale
		}
	}

	func configure(at position: CGPoint) {
		self.position = position

		createBackground()
		createCharNode()
		addCropNode()
	}

	private func createBackground() {
		let background = SKSpriteNode(imageNamed: "whackHole")
		addChild(background)
	}

	private func createCharNode() {
		charNode = SKSpriteNode(imageNamed: "penguinGood")
		charNode.position = .init(x: 0, y: -hiddenOffset)
		charNode.name = "character"
	}

	private func addCropNode() {
		let cropNode = SKCropNode()
		cropNode.position = .init(x: 0, y: 15)
		cropNode.zPosition = 1
		cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

		cropNode.addChild(charNode)
		addChild(cropNode)
	}

	// MARK: - Actions
	func show(hideTime: TimeInterval) {
		if isVisible { return }

		charNodeScale = 1

		charNode.run(.moveBy(x: 0, y: hiddenOffset, duration: 0.05))
		isVisible = true
		isHit = false

		let isBad = Int.random(in: 0..<3) == 0
		let suffix = isBad ? "Bad" : "Good"

		charNode.texture = SKTexture(imageNamed: "penguin\(suffix)")
		charNode.name = (isBad ? PenguinType.bad : PenguinType.good).rawValue

		Task {
			try await Task.sleep(for: .seconds(hideTime * 3.5))
			hide()
		}
	}

	func hit() {
		isHit = true

		let delay = SKAction.wait(forDuration: 0.25)
		let hide = SKAction.moveBy(x: 0, y: -hiddenOffset, duration: 0.5)
		let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
		let sequence = SKAction.sequence([delay, hide, notVisible])

		charNode.run(sequence)
	}

	func hide() {
		if !isVisible { return }

		charNode.run(.moveBy(x: 0, y: -hiddenOffset, duration: 0.05))
		isVisible = false
	}
}
