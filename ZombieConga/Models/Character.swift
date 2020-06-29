//
//  Character.swift
//  ZombieConga
//
//  Created by Dimasno1 on 6/28/20.
//  Copyright © 2020 Dimasno1. All rights reserved.
//

import Foundation
import SpriteKit

enum Character {
    case zombie(index: Int)
    case cat
    case enemy
}

extension Character {
    var name: String {
        switch self {
        case let .zombie(index):
            return "zombie\(index)"
        case .cat:
            return "cat"
        case .enemy:
            return "granny"
        }
    }
    
    var node: SKSpriteNode {
        return SKSpriteNode(imageNamed: name)
    }
}
