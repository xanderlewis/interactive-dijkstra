//
//  Edge.swift
//  Dijkstra
//
//  Created by Xander Lewis on 15/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import UIKit
import SpriteKit

class Edge: SKShapeNode {
    
    var startVertex: Vertex
    var endVertex: Vertex
    
    let width: CGFloat = 6
    
    private var distance: Int?
    
    var highlighted = false {
        didSet {
            if highlighted {
                // Make highlighted
                strokeColor = UIColor(red:1.00, green:0.78, blue:0.00, alpha:1.0)
            } else {
                // Make unhighlighted
                strokeColor = UIColor.white
            }
        }
    }
    
    var label: SKLabelNode!
    
    func setDistance(to newDistance: Int) {
        distance = newDistance
        if distance != nil {
            label.text = "\(distance!)"
        } else {
            label.text = nil
        }
        
    }
    
    private func evaluateLabelPosition() {
        let midpoint = CGPoint.midpoint(ofPoint: startVertex.position, andPoint: endVertex.position)
        
        label.position = convert(midpoint, from: self)
    }
    
    init(startVertex start: Vertex, endVertex end: Vertex) {
        startVertex = start
        endVertex = end
        
        label = SKLabelNode()
        label.fontName = UIFont.boldSystemFont(ofSize: 14).fontName
        label.fontSize = 14
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.zPosition = 15
        label.fontColor = UIColor.gray
        
        super.init()
        
        name = "edge"
        
        self.addChild(label)
        evaluateLabelPosition()
        
        zPosition = 0
        
        let line = UIBezierPath()
        line.move(to: startVertex.position)
        line.addLine(to: endVertex.position)
        line.lineWidth = width
        
        lineWidth = width
        
        path = line.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
