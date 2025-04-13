//
//  GameScene.swift
//  SpaceRace
//
//  Created by Виталий Овсянников on 13.04.2025.
//

import Combine
import SpriteKit

class GameScene: SKScene {

	private var starfield: SKEmitterNode!
	private var player: SKSpriteNode!
	private var scoreLabel: SKLabelNode!

	private var score = 0 {
		didSet { scoreLabel.text = "Score: \(score)" }
	}

	private var possibleEnemies = EnemyType.allCases
	private var gameTimer: AnyCancellable?
	private var isGameOver = false


	// MARK: - Lifecycle
	override func didMove(to view: SKView) {
		setupStarfield()
		setupPlayer()
		setupScoreLabel()
		setupPhysicsWorld()
		setupTimer()
	}


	override func update(_ currentTime: TimeInterval) {
		for node in children where node.position.x < -300 {
			node.removeFromParent()
		}

		if !isGameOver {
			score += 1
		}
	}


	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }

		var location = touch.location(in: self)
		let offset: CGFloat = 100

		if location.y < offset {
			location.y = offset
		} else if location.y > bounds.height - offset {
			location.y = bounds.height - offset
		}

		player.position = location
	}

	func didBegin(_ contact: SKPhysicsContact) {
		let explosion = SKEmitterNode(fileNamed: "explosion")!
		explosion.position = player.position

		addChild(explosion)

		player.removeFromParent()
		isGameOver = true
		gameTimer?.cancel()
	}


	// MARK: - Setup
	private func setupStarfield() {
		backgroundColor = .black

		starfield = .init(fileNamed: "starfield")!
		starfield.position = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
		starfield.advanceSimulationTime(10)
		starfield.zPosition = -1

		addChild(starfield)
	}

	private func setupPlayer() {
		player = SKSpriteNode(imageNamed: "player")
		player.position = CGPoint(x: 100, y: self.bounds.midY)
		player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
		player.physicsBody?.contactTestBitMask = 1

		addChild(player)
	}

	private func setupScoreLabel() {
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.position = CGPoint(x: 16, y: 16)
		scoreLabel.horizontalAlignmentMode = .left
		score = 0

		addChild(scoreLabel)
	}

	private func setupPhysicsWorld() {
		physicsWorld.gravity = .zero
		physicsWorld.contactDelegate = self
	}

	private func setupTimer() {
		gameTimer = Timer.publish(every: 0.35, tolerance: 0.1, on: .main, in: .common)
			.autoconnect()
			.sink { _ in self.createEnemy() }
	}

	private func createEnemy() {
		guard let enemy = possibleEnemies.randomElement() else { return }

		let yPosition = CGFloat.random(in: (self.bounds.minY + 50)...(self.bounds.maxY - 50))
		let newEnemy = SKSpriteNode(imageNamed: enemy.rawValue)
		newEnemy.position = CGPoint(x: self.bounds.maxX + 100, y: yPosition)

		let physicsBody = SKPhysicsBody(texture: newEnemy.texture!, size: newEnemy.size)
		physicsBody.contactTestBitMask = 1
		physicsBody.velocity = CGVector(dx: -500, dy: 0)
		physicsBody.angularVelocity = 5
		physicsBody.linearDamping = 0
		physicsBody.angularDamping = 0
		newEnemy.physicsBody = physicsBody

		addChild(newEnemy)
	}
}


// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
	
}
