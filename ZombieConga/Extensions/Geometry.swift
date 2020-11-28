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

