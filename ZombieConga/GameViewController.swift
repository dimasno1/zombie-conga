//
//  GameViewController.swift
//  ZombieConga
//
//  Created by Dimasno1 on 6/12/20.
//  Copyright © 2020 Dimasno1. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var skView: SKView {
        return self.view as! SKView
    }
    
    override func loadView() {
        view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: .projectHardcoded)
        scene.scaleMode = .aspectFill
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

private extension CGSize {
    static var projectHardcoded: CGSize {
        return CGSize(width: 2048, height: 1536)
    }
}
