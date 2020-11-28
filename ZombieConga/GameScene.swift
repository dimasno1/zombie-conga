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
    }
    
    override func update(_ currentTime: TimeInterval) {
        defer { keepInBounds(zombie: zombie) }
        intervalCounter.update(with: currentTime)
        
        let distance = lastTouchLocation?.distance(to: zombie.position) ?? 0.0
        let currentFrameDistance = zombieMovePointsPerSec * intervalCounter.secSinceLastUpdate
        
        if distance <= currentFrameDistance {
            zombie.position = lastTouchLocation ?? zombie.position
            velocity = .zero
            
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
        let distance = vector - zombie.position
        let direction = distance.normalized
            
        velocity = direction * zombieMovePointsPerSec
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
    
    private var lastTouchLocation: CGPoint?
    
    private var velocity = CGPoint.zero
    private let intervalCounter = UpdateIntervalCounter()
    private let zombie = Character.zombie(index: 1).node
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
