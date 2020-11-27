//
//  CGPoint+Extensions.swift
//  ZombieConga
//
//  Created by Admin on 8/7/20.
//  Copyright © 2020 Dimasno1. All rights reserved.
//

import UIKit

extension CGPoint {
    mutating func translateBy(x: CGFloat = 0, y: CGFloat = 0) {
        self.x += x
        self.y += y
    }
    
    mutating func translateBy(point: CGPoint) {
        self.translateBy(x: point.x, y: point.y)
    }
}
