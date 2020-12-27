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

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(with:)))
        view.addGestureRecognizer(tapRecognizer)
    
        background.place(in: self, at: .zero)
        zombie.place(in: self, at: CGPoint(x: 400, y: 400))
        
        let spawnEnemy = SKAction.run { [weak self] in
            self?.spawnEnemy()
        }
        let spawnAndWait = SKAction.sequence([spawnEnemy, .wait(forDuration: 5.0)])
        let spawnCatAndWait = SKAction.sequence([.run { [weak self] in self?.spawnCat() }, .wait(forDuration: 1.0)])
        
        run(.repeatForever(spawnAndWait))
        run(.repeatForever(spawnCatAndWait))
    }
    
    override func update(_ currentTime: TimeInterval) {
        defer { keepInBounds(zombie: zombie) }
        intervalCounter.update(with: currentTime)
        
        let distance = lastTouchLocation?.distance(to: zombie.position) ?? 0.0
        let currentFrameDistance = zombieMovePointsPerSec * intervalCounter.secSinceLastUpdate
        
        if distance <= currentFrameDistance {
            zombie.position = lastTouchLocation ?? zombie.position
            velocity = .zero
            setZombieWalk(animated: false)
            
            return
        }
        
        rotateSprite(zombie, to: velocity, radiansPerSec: zombieRotateRadiansPerSec)
        move(sprite: zombie, velocity: velocity)
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
        setZombieWalk(animated: true)
        let distance = vector - zombie.position
        let direction = distance.normalized
            
        velocity = direction * zombieMovePointsPerSec
    }
    
    func spawnEnemy() {
        let enemy = Character.enemy.node
        let respawnPosition = CGPoint(
            x: size.width + enemy.size.width / 2,
            y: .random(in: playableRect.minY + enemy.size.height / 2 ... playableRect.maxY - enemy.size.height / 2)
        )
        enemy.place(in: self, at: respawnPosition)
        moveNode(enemy, to: .init(x: -enemy.size.width / 2, y: enemy.position.y), removeAfterReachingTarget: true)
    }
    
    func spawnCat() {
        let cat = Character.cat.node
        let respawnPosition = CGPoint(
            x: .random(in: playableRect.minX ... playableRect.maxX),
            y: .random(in: playableRect.minY ... playableRect.maxY)
        )
        cat.setScale(0)
        cat.place(in: self, at: respawnPosition)

        let sequence = SKAction.sequence([
            .scale(to: 1.0, duration: 0.5),
            .wait(forDuration: 10.0),
            .scale(to: 0.0, duration: 0.5),
            .removeFromParent()
        ])
        cat.run(sequence)
    }
    
    func moveNode(_ node: SKNode, to target: CGPoint, removeAfterReachingTarget remove: Bool) {
        let actions: [SKAction?] = [
            .move(to: target, duration: 5.0),
            remove ? .removeFromParent() : nil
        ]
        node.run(.sequence(actions.compactMap { $0 }))
    }
    
    func moveNode(_ node: SKNode, throughTargets targest: [CGPoint], delayAtControlPoints: TimeInterval, duration: TimeInterval) {
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
    
    private func setZombieWalk(animated: Bool) {
        guard animated else {
            zombie.removeAction(forKey: AnimationKey.walkAnimation)
            return
        }
        
        if zombie.isActiveAnimation(for: AnimationKey.walkAnimation) {
            return
        }
        
        zombie.run(
            .repeatForever(Character.zombie.walkAnimation),
            withKey: AnimationKey.walkAnimation
        )
    }
    
    private var lastTouchLocation: CGPoint?
    
    private var velocity = CGPoint.zero
    private let intervalCounter = UpdateIntervalCounter()
    private let zombie = Character.zombie.node
}

extension SKNode {
    func isActiveAnimation(for key: String) -> Bool {
        return self.action(forKey: key) != nil
    }
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
    static let walkAnimation = "walk_animation"
}
