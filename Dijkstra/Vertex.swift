//
//  Vertex.swift
//  Dijkstra
//
//  Created by Xander Lewis on 14/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import UIKit
import SpriteKit

class Vertex: SKSpriteNode {
    static var ids: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
                                "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var connections: Dictionary<Vertex, Int> = [:]
    var id: String
    
    let label: SKLabelNode!
    
    var bouncing = false
    var spinning = false
    
    var isStartVertex: Bool = false {
        didSet {
            if isStartVertex {
                color = UIColor(red: 0, green: 0.8, blue: 0, alpha: 1)
            } else {
                color = UIColor.darkGray
            }
        }
    }
    var isEndVertex: Bool = false {
        didSet {
            if isEndVertex {
                color = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
            } else {
                color = UIColor.darkGray
            }
        }
    }
    
    func bounce() {
        if !bouncing {
            // Bouncing animation for vertex
            let height: CGFloat = 0.5
            
            let grow = SKAction.scale(by: 1+height, duration: 0.1)
            let shrink = SKAction.scale(by: -height, duration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0)
            
            bouncing = true
            
            run(SKAction.sequence([grow, shrink])) { self.bouncing = false }
        }
    }
    
    func spin() {
        if !spinning {
            // Spinning animation for vertex
            
            let left = SKAction.rotate(toAngle: CGFloat(-M_PI/10), duration: 0.1)
            let right = SKAction.rotate(toAngle: CGFloat(M_PI/8), duration: 0.1)
            let centre = SKAction.rotate(toAngle: 0, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
            
            spinning = true
            
            run(SKAction.sequence([left, right, centre])) { self.spinning = false }
        }
    }
    
    func liftUp() {
        // Lifting up vertex
        
        if isStartVertex {
            color = UIColor(red: 0, green: 0.4, blue: 0, alpha: 1)
        } else {
            if isEndVertex {
                color = UIColor(red: 0.4, green: 0, blue: 0, alpha: 1)
            } else {
                color = UIColor(white: 0.1, alpha: 1.0)
            }
        }
    }
    
    func putDown() {
        // Putting down vertex
        
        if isStartVertex {
            isStartVertex = true
        } else {
            if isEndVertex {
                isEndVertex = true
            } else {
                color = UIColor.darkGray
            }
        }
    }
    
    func connect(toVertex vertex: Vertex, withDistance distance: Int) {
        connections[vertex] = distance
    }
    
    func connectInBothDirections(toVertex vertex: Vertex, withDistance distance: Int) {
        self.connect(toVertex: vertex, withDistance: distance)
        vertex.connect(toVertex: self, withDistance: distance)
    }
    
    init?(position p: CGPoint) {
        if Vertex.ids.first != nil {
            
            id = Vertex.ids.removeFirst()
            
            label = SKLabelNode(text: id)
            
            super.init(texture: nil, color: UIColor.darkGray, size: CGSize(width: 30, height: 30))
            name = "vertex"
            position = p
            zPosition = 5
            
            colorBlendFactor = 1
            
            label.fontSize = 20
            label.fontName = UIFont.boldSystemFont(ofSize: 20).fontName
            label.verticalAlignmentMode = .center
            label.color = UIColor.white
            label.position = CGPoint(x: 0, y: 0)
            label.zPosition = 10
            self.addChild(label)
            
        } else {
            return nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
