//
//  GameScene.swift
//  Pachinko
//
//  Created by Виталий Овсянников on 31.03.2025.
//

import SpriteKit

class GameScene: SKScene {
	private var editLabel: SKLabelNode!
	private var isEditing: Bool = false {
		didSet {
			editLabel.text = isEditing ? "Done" : "Edit"
		}
	}

	private var scoreLabel: SKLabelNode!
	private var score: Int = 0 {
		didSet { scoreLabel.text = "Score: \(score)"}
	}

    override func didMove(to view: SKView) {
		addBackground()
		addPhysics()
		addSceneObjects()
		addEditLabel()
		addScoreLabel()
    }

	private func addBackground() {
		let background = SKSpriteNode(imageNamed: "background")
		background.position = .init(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1

		addChild(background)
	}

	private func addPhysics() {
		physicsBody = .init(edgeLoopFrom: frame)
		physicsWorld.contactDelegate = self
	}

	private func addSceneObjects() {
		(0...4).forEach { offset in
			makeSlot(at: (256 * offset) + 128, isGood: offset.isMultiple(of: 2))
		}

		(0...5).forEach { offset in
			makeBouncer(at: 256 * offset)
		}
	}

	private func addEditLabel() {
		editLabel = SKLabelNode(fontNamed: "Chalkduster")
		editLabel.position = .init(x: 80, y: 700)
		isEditing = false


		addChild(editLabel)
	}

	private func addScoreLabel() {
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.horizontalAlignmentMode = .right
		scoreLabel.position = CGPoint(x: 980, y: 700)

		score = 0

		addChild(scoreLabel)
	}

	private func makeBouncer(at offset: Int) {
		let bouncer = SKSpriteNode(imageNamed: "bouncer")
		bouncer.position = .init(x: offset, y: 0)
		bouncer.physicsBody = .init(circleOfRadius: bouncer.size.width / 2)
		bouncer.physicsBody?.isDynamic = false
		bouncer.zPosition = 1

		addChild(bouncer)
	}

	private func makeSlot(at offset: Int, isGood: Bool) {
		let slotType = (isGood ? Objects.good : Objects.bad).rawValue
		let slotBase = SKSpriteNode(imageNamed: "slotBase" + slotType)
		let slotGlow = SKSpriteNode(imageNamed: "slotGlow" + slotType)

		let position = CGPoint(x: offset, y: 0)
		slotBase.position = position
		slotGlow.position = position

		slotBase.physicsBody = .init(rectangleOf: slotBase.size)
		slotBase.physicsBody?.isDynamic = false
		slotBase.name = slotType

		let spin = SKAction.rotate(byAngle: .pi, duration: 10)
		let spinForever = SKAction.repeatForever(spin)

		slotGlow.run(spinForever)

		addChild(slotBase)
		addChild(slotGlow)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }

		let location = touch.location(in: self)
		let nodes = nodes(at: location)

		if nodes.contains(editLabel) {
			isEditing.toggle()
			return
		}

		if isEditing {
			createObstacle(at: location)
		} else {
			createBall(at: location)
		}
	}

	/// Creates an obstacle of random rotation and size
	private func createObstacle(at location: CGPoint) {
		let size = CGSize(width: Int.random(in: 16...128), height: 16)
		let boxColor = UIColor(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1),
			alpha: 1
		)

		let box = SKSpriteNode(color: boxColor, size: size)
		box.zRotation = .random(in: 0...3)
		box.position = location
		box.physicsBody = SKPhysicsBody(rectangleOf: size)
		box.physicsBody?.isDynamic = false

		addChild(box)
	}

	private func createBall(at location: CGPoint) {
		let ball = SKSpriteNode(imageNamed: "ballRed")
		let physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
		physicsBody.restitution = 0.4
		physicsBody.contactTestBitMask = physicsBody.collisionBitMask

		ball.physicsBody = physicsBody
		ball.position = .init(x: location.x, y: 700)
		ball.name = Objects.ball.rawValue

		addChild(ball)
	}
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
	public func didBegin(_ contact: SKPhysicsContact) {
		guard
			let nodeA = contact.bodyA.node,
			let nodeB = contact.bodyB.node
		else { return }

		if nodeA.name == Objects.ball.rawValue {
			collision(between: nodeA, object: nodeB)
		} else if nodeB.name == Objects.ball.rawValue {
			collision(between: nodeB, object: nodeA)
		}
	}

	private func collision(between ball: SKNode, object: SKNode) {
		if object.name == Objects.good.rawValue {
			destroy(ball)
			score += 1
		} else if object.name == Objects.bad.rawValue {
			destroy(ball)
			score -= 1
		}
	}

	private func destroy(_ node: SKNode) {
		defer { node.removeFromParent() }

		guard let fireParticles = SKEmitterNode(fileNamed: "FireParticles") else { return }
		fireParticles.position = node.position
		addChild(fireParticles)
	}
}

extension GameScene {
	enum Objects: String {
		case ball = "Ball"
		case good = "Good"
		case bad = "Bad"
	}
}
