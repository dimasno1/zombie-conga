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
    
    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }
    
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    static func *= (point: inout CGPoint, scalar: CGFloat)  {
        point = CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
}
