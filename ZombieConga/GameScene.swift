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
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        let background = SKSpriteNode.background
        background.anchorPoint = .zero
    
        background.place(in: self, at: .zero)
        zombie.place(in: self, at: CGPoint(x: 400, y: 400))
    }
    
    override func update(_ currentTime: TimeInterval) {
        intervalCounter.update(with: currentTime)
        move(sprite: zombie, velocity: .init(x: zombieMovePointsPerSec, y: 0))
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(
            x: velocity.x * intervalCounter.dtFraction,
            y: velocity.y * intervalCounter.dtFraction
        )
        sprite.position.translateBy(point: amountToMove)
    }

    let zombieMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    
    private let intervalCounter = UpdateIntervalCounter()
    private let zombie = Character.zombie(index: 1).node
}

final class UpdateIntervalCounter {
    var dtFraction: CGFloat {
        return CGFloat(dt)
    }
    
    func update(with currentTime: TimeInterval) {
        dt = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
    }
    
    private var dt: TimeInterval = 0
    private var lastUpdateTime: TimeInterval = 0
}
