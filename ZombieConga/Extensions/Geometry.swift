//
//  Geometry.swift
//  ZombieConga
//
//  Created by Dimasno1 on 11/28/20.
//  Copyright © 2020 Dimasno1. All rights reserved.
//

import UIKit

typealias Vector = CGPoint

extension Vector {
    static func -(l: Vector, r: Vector) -> Vector {
        return Vector(x: l.x - r.x, y: l.y - r.y)
    }

    var length: CGFloat {
        return sqrt(x * x + y * y)
    }
    
    var angle: CGFloat {
        return atan2(y, x)
    }
    
    var normalized: CGPoint {
        return self / length
    }
    
    func distance(to vector: Vector) -> CGFloat {
        return (vector - self).length
    }
}

extension CGFloat {
    static func shortestAngleBetween(_ a1: CGFloat, _ a2: CGFloat) -> CGFloat {
        let doublePi: CGFloat = .pi * 2
        var angle = (a2 - a1).truncatingRemainder(dividingBy: doublePi)
        
        if angle >= .pi {
            angle -= doublePi
        }
        if angle <= -.pi {
            angle += doublePi
        }
        return angle
    }
    
    var sign: CGFloat {
        return self >= 0 ? 1 : -1
    }
}
