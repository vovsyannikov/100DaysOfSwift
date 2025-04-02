//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by Виталий Овсянников on 02.04.2025.
//

import SpriteKit

class GameScene: SKScene {
	private var slots = [WhackSlot]()

	private let scoreLabel: SKLabelNode = {
		$0.position = .init(x: 8, y: 8)
		$0.horizontalAlignmentMode = .left
		$0.fontSize = 48
		return $0
	}(SKLabelNode(fontNamed: "Chalkduster"))

	private var score = 0 {
		didSet { scoreLabel.text = "Score: \(score)" }
	}
	private var rounds = 0
	private let maxRounds = 30

	private var popupTime = 0.85

	override func didMove(to view: SKView) {
		createBackground()
		addScoreLabel()
		createSlots()

		Task {
			try await Task.sleep(for: .seconds(1))
			createEnemy()
		}
	}


	private func createBackground() {
		let background = SKSpriteNode(imageNamed: "whackBackground")
		background.position = CGPoint(x: size.width / 2, y: size.height / 2)
		background.blendMode = .replace
		background.zPosition = -1

		addChild(background)
	}

	private func addScoreLabel() {
		addChild(scoreLabel)
		score = 0
	}

	private func createSlots() {
		func getPosition(for i: Int, xOffset: CGFloat, yOffset: CGFloat) -> CGPoint {
			.init(x: 100 + xOffset + CGFloat(i * 170), y: 410 + yOffset)
		}

		(0..<5).forEach { createSlot(at: getPosition(for: $0, xOffset: 0, yOffset: 0)) }
		(0..<4).forEach { createSlot(at: getPosition(for: $0, xOffset: 80, yOffset: -90)) }
		(0..<5).forEach { createSlot(at: getPosition(for: $0, xOffset: 0, yOffset: -180)) }
		(0..<4).forEach { createSlot(at: getPosition(for: $0, xOffset: 80, yOffset: -270)) }
	}

	private func createSlot(at position: CGPoint) {
		let slot = WhackSlot()
		slot.configure(at: position)
		addChild(slot)
		slots.append(slot)
	}

	private func createEnemy() {
		rounds += 1

		if rounds == maxRounds {
			slots.forEach { $0.hide() }

			let gameOverNode = SKSpriteNode(imageNamed: "gameOver")
			gameOverNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
			gameOverNode.zPosition = 1

			addChild(gameOverNode)

			return
		}

		popupTime *= 0.991

		slots.shuffle()
		slots[0].show(hideTime: popupTime)

		let chances = [4, 8, 10, 11]
		for i in 1...4 {
			let chanceIndex = min(chances.count, i - 1)
			let showSlot = Int.random(in: 0...12) > chances[chanceIndex]
			if showSlot {
				slots[i].show(hideTime: popupTime)
			}
		}

		let minDelay = popupTime / 2
		let maxDelay = popupTime * 2
		let delay = Double.random(in: minDelay...maxDelay)

		Task {
			try await Task.sleep(for: .seconds(delay))
			createEnemy()
		}
	}


	// MARK: - Actions
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		let tappedNodes = nodes(at: location)

		for node in tappedNodes {
			guard let whackSlot = node.parent?.parent as? WhackSlot,
				  whackSlot.isVisible,
				  !whackSlot.isHit
			else { continue }

			whackSlot.hit()

			if node.name == PenguinType.good.rawValue {
				score -= 5

				run(.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
			} else if node.name == PenguinType.bad.rawValue {
				whackSlot.charNodeScale = 0.85
				score += 1

				run(.playSoundFileNamed("whack.caf", waitForCompletion: false))
			}
		}
	}
}
