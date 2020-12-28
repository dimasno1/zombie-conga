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
   
    var walkAnimation: SKAction {
        switch self {
        case .zombie:
            let maxValue = max(numberOfTextures, 1)
            let framesIndexes = Array(1 ... maxValue) + [maxValue - 1, maxValue - 2]
            
            guard maxValue <= textures.count else {
                return .animate(with: textures, timePerFrame: 0.1)
            }
            
            let frames = framesIndexes.map { textures[$0 - 1] }
            
            return .animate(with: frames, timePerFrame: 0.1)
            
        default:
            return .animate(with: textures, timePerFrame: 0.1)
        }
    }

    private var numberOfTextures: Int {
        switch self {
        case .zombie:
            return 4
        default:
            return 1
        }
    }

    private var textures: [SKTexture] {
        return Array(1 ... numberOfTextures).map { .init(imageNamed: "\(name)\($0)") }
            
    }
}
