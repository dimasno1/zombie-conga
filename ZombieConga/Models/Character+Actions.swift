//
//  Character+Actions.swift
//  ZombieConga
//
//  Created by Dimasno1 on 1.02.22.
//  Copyright © 2022 Dimasno1. All rights reserved.
//

import SpriteKit

extension Character {
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
         case .zombie: return 4
         default: return 1
         }
     }

     private var textures: [SKTexture] {
         return Array(1 ... numberOfTextures).map { .init(imageNamed: "\(name)\($0)") }
             
     }
}
