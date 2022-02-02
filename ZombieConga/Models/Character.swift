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
    case zombie
    case cat
    case enemy
}

extension Character {
    var name: String {
        switch self {
        case .zombie:
            return "zombie"
        case .cat:
            return "cat"
        case .enemy:
            return "granny"
        }
    }
    
    var node: SKSpriteNode {
        switch self {
        case .zombie:
            return SKSpriteNode(imageNamed: "\(name)1")
        default:
            return SKSpriteNode(imageNamed: name)
        }
    }
}
