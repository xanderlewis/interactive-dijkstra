//
//  GameViewController.swift
//  Dijkstra
//
//  Created by Xander Lewis on 14/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let scene = Scene(size: view.bounds.size)
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @IBAction func findShortestPathTapped() {
        let skView = view as! SKView
        let skScene = skView.scene as! Scene
        skScene.pathfind()
    }
    
    @IBAction func clearTapped() {
        let skView = view as! SKView
        let skScene = skView.scene as! Scene
        skScene.clearGraph()
    }
}
