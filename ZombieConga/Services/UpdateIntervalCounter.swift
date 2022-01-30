//
//  UpdateIntervalCounter.swift
//  ZombieConga
//
//  Created by Admin on 8/7/20.
//  Copyright © 2020 Dimasno1. All rights reserved.
//

import UIKit

final class UpdateIntervalCounter {
    var secSinceLastUpdate: CGFloat {
        return CGFloat(dt)
    }
    
    func update(with currentTime: TimeInterval) {
        dt = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
    }
    
    private var dt: TimeInterval = 0
    private var lastUpdateTime: TimeInterval = 0
}
