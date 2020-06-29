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
    
        place(node: background, at: .zero)
        place(node: zombie, at: CGPoint(x: 400, y: 400))
    }
    
    override func update(_ currentTime: TimeInterval) {
        zombie.position.translateBy(x: 2)
    }
    
    private func place(node: SKNode, at position: CGPoint) {
        node.position = position
        addChild(node)
    }
    
    private let zombie = Character.zombie(index: 1).node
}

extension SKSpriteNode {
    static var background: SKSpriteNode {
        let back = SKSpriteNode(imageNamed: "background1")
        back.zPosition = -1.0
        return back
    }
}

extension CGPoint {
    mutating func translateBy(x: CGFloat = 0, y: CGFloat = 0) {
        self.x += x
        self.y += y
    }
}
