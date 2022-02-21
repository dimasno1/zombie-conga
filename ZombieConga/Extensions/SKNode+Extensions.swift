//
//  SKNode+Extensions.swift
//  ZombieConga
//
//  Created by Admin on 8/7/20.
//  Copyright © 2020 Dimasno1. All rights reserved.
//

import SpriteKit

extension SKNode {
    func place(in parent: SKNode, at position: CGPoint) {
        self.position = position
        parent.addChild(self)
    }

    func isActiveAnimation(for key: String) -> Bool {
        return self.action(forKey: key) != nil
    }
}

extension SKNode {
    static var background: SKSpriteNode {
        let back = SKSpriteNode(imageNamed: "background1")
        back.zPosition = -1.0
        return back
    }
}
