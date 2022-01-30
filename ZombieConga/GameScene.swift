//
//  GameScene.swift
//  ZombieConga
//
//  Created by Dimasno1 on 6/12/20.
//  Copyright © 2020 Dimasno1. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    let playableRect: CGRect
    let zombieRotateRadiansPerSec: CGFloat = .pi * 4
    let zombieMovePointsPerSec: CGFloat = 480.0
    
    override init(size: CGSize) {
        let playableHeight = size.width / UIScreen.main.landscapeAspectRation
        let playableMargin = (size.height - playableHeight) / 2.0
        
        self.playableRect = CGRect(
            x: 0,
            y: playableMargin,
            width: size.width,
            height: playableHeight
        )
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        let background = SKSpriteNode.background
        background.anchorPoint = .zero
        background.place(in: self, at: .zero)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(with:)))
        view.addGestureRecognizer(tapRecognizer)

        spawnZombie()
        spawnEnemiesForever()
    }

    // MARK: Game loop
    override func update(_ currentTime: TimeInterval) {
        defer { keepInBounds(zombie: zombie) }
        intervalCounter.update(with: currentTime)
        
        let distance = lastTouchLocation?.distance(to: zombie.position) ?? 0.0
        let currentFrameDistance = zombieMovePointsPerSec * intervalCounter.secSinceLastUpdate
        
        if distance <= currentFrameDistance {
            zombie.position = lastTouchLocation ?? zombie.position
            velocity = .zero
            setZombieWalkAnimation(enabled: false)
            
            return
        }
        
        rotateSprite(zombie, to: velocity, radiansPerSec: zombieRotateRadiansPerSec)
        move(sprite: zombie, velocity: velocity)
    }
    
    // Called after update(_ :) method
    override func didEvaluateActions() {
        checkZombieCollisions()
    }

    func sceneTouched(at location: CGPoint) {
        lastTouchLocation = location
        moveZombieToward(vector: location)
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * intervalCounter.secSinceLastUpdate
        sprite.position.translateBy(point: amountToMove)
    }
    
    func moveZombieToward(vector: Vector) {
        setZombieWalkAnimation(enabled: true)
        let distance = vector - zombie.position
        let direction = distance.normalized
            
        velocity = direction * zombieMovePointsPerSec
    }
    
    func spawnEnemy() {
        let enemy = Character.enemy.node
        enemy.name = Character.enemy.name
        let respawnPosition = CGPoint(
            x: size.width + enemy.size.width / 2,
            y: .random(in: playableRect.minY + enemy.size.height / 2 ... playableRect.maxY - enemy.size.height / 2)
        )
        enemy.place(in: self, at: respawnPosition)
        moveNode(enemy, to: .init(x: -enemy.size.width / 2, y: enemy.position.y), removeAfterReachingTarget: true)
    }
    
    func spawnCat() {
        let cat = Character.cat.node
        cat.name = Character.cat.name
        let respawnPosition = CGPoint(
            x: .random(in: playableRect.minX ... playableRect.maxX),
            y: .random(in: playableRect.minY ... playableRect.maxY)
        )
        cat.setScale(0)
        cat.place(in: self, at: respawnPosition)
        cat.zRotation = -.pi / 16.0
        
        let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let scale  = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        
        let leftWiggle = SKAction.rotate(byAngle: .pi / 8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let wiggle = SKAction.sequence([leftWiggle, rightWiggle])
        let group = SKAction.group([scale, wiggle])

        let sequence = SKAction.sequence([
            .scale(to: 1.0, duration: 0.5),
            .repeat(group, count: 10),
            .scale(to: 0.0, duration: 0.5),
            .removeFromParent()
        ])
        cat.run(sequence)
    }
    
    func checkZombieCollisions() {
        for enemy in hitEnemies {
            zombieHit(characterNode: enemy)
            run(.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false))
        }
        for cat in hitCats {
            zombieHit(characterNode: cat)
            run(.playSoundFileNamed("hitCat.wav", waitForCompletion: false))
        }
    }

    func zombieHit(characterNode: SKSpriteNode) {
        characterNode.removeFromParent()
    }
    
    func moveNode(_ node: SKNode, to target: CGPoint, removeAfterReachingTarget remove: Bool) {
        let actions: [SKAction] = [
            .move(to: target, duration: 5.0),
            remove ? .removeFromParent() : nil
        ].compactMap { $0 }
        node.run(.sequence(actions))
    }
    
    func moveNode(
        _ node: SKNode,
        throughTargets targest: [CGPoint],
        delayAtControlPoints: TimeInterval,
        duration: TimeInterval
    ) {
        let actions = targest.map { SKAction.moveBy(x: $0.x, y: $0.y, duration: duration / Double(targest.count)) }
        let revActions = actions.reversed().map { $0.reversed() }

        let wait = SKAction.wait(forDuration: delayAtControlPoints)
        let withPauses =  Array((actions + revActions).map { [$0] }.joined(separator: [wait]))

        let sequence = SKAction.sequence(withPauses)
        
        let repeatAction = SKAction.repeatForever(sequence)
        node.run(repeatAction)
    }
    
    @objc
    private func tapRecognized(with recognizer: UITapGestureRecognizer) {
        if let location = view?.convert(recognizer.location(in: view), to: self) {
            sceneTouched(at: location)
        }
    }

    private func spawnEnemiesForever() {
        let spawnEnemy = SKAction.run { [weak self] in
            self?.spawnEnemy()
        }
        let spawnEnemyAndWait = SKAction.sequence([spawnEnemy, .wait(forDuration: 5.0)])
        let spawnCatAndWait = SKAction.sequence([.run { [weak self] in self?.spawnCat() }, .wait(forDuration: 1.0)])
        
        run(.repeatForever(spawnEnemyAndWait))
        run(.repeatForever(spawnCatAndWait))
    }

    private func spawnZombie() {
        zombie.place(in: self, at: CGPoint(x: 400, y: 400))
    }

    private func keepInBounds(zombie: SKNode) {
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x.changeSign()
        }
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x.changeSign()
        }
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y.changeSign()
        }
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y.changeSign()
        }
    }

    private func rotateSprite(_ sprite: SKNode, to vector: Vector, radiansPerSec: CGFloat) {
        let shortest = CGFloat.shortestAngleBetween(sprite.zRotation, vector.angle)
        let amountToRotate = min(radiansPerSec * intervalCounter.secSinceLastUpdate, abs(shortest))
        
        sprite.zRotation += shortest.sign * amountToRotate
    }
    
    private func setZombieWalkAnimation(enabled: Bool) {
        guard enabled else {
            zombie.removeAction(forKey: AnimationKey.zombieWalk)
            return
        }
        
        if zombie.isActiveAnimation(for: AnimationKey.zombieWalk) {
            return
        }
        
        zombie.run(
            .repeatForever(Character.zombie.walkAnimation),
            withKey: AnimationKey.zombieWalk
        )
    }

    private func zombieCollisionsWithNodes(named: String, insets: UIEdgeInsets = .zero) -> [SKSpriteNode] {
        var nodes: [SKSpriteNode] = []
        enumerateChildNodes(withName: named) { [weak self] node, _ in
            guard let self = self, let node = node as? SKSpriteNode else {
                return
            }
            if node.frame.inset(by: insets).intersects(self.zombie.frame) {
                nodes.append(node)
            }
        }
        return nodes
    }
        
    private var hitCats: [SKSpriteNode] {
        return zombieCollisionsWithNodes(named: Character.cat.name)
    }
    
    private var hitEnemies: [SKSpriteNode] {
        return zombieCollisionsWithNodes(
            named: Character.enemy.name,
            insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        )
    }

    private var lastTouchLocation: CGPoint?
    
    private var velocity = CGPoint.zero
    private let intervalCounter = UpdateIntervalCounter()
    private let zombie = Character.zombie.node
}

private extension CGFloat {
    mutating func changeSign() {
        self = -self
    }
}

private extension UIScreen {
    var landscapeAspectRation: CGFloat {
        return bounds.width / bounds.height
    }
}

private enum AnimationKey {
    static let zombieWalk = "zombie_walk_animation"
}
