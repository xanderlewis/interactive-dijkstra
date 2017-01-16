//
//  PullingEdge.swift
//  Dijkstra
//
//  Created by Xander Lewis on 15/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import UIKit
import SpriteKit

class PullingEdge: SKShapeNode {
    
    var width: CGFloat = 6
    
    var start: CGPoint {
        didSet {
            let line = UIBezierPath()
            line.move(to: start)
            line.addLine(to: end)
            line.lineWidth = width
            path = line.cgPath
        }
    }
    
    var end: CGPoint {
        didSet {
            let line = UIBezierPath()
            line.move(to: start)
            line.addLine(to: end)
            line.lineWidth = width
            path = line.cgPath
        }
    }
    
    func disappear() {
        isHidden = true
        start = CGPoint.zero
        end = CGPoint.zero
    }
    
    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
        
        super.init()
        
        zPosition = 1
        
        let line = UIBezierPath()
        line.move(to: start)
        line.addLine(to: end)
        
        path = line.cgPath
        
        lineWidth = width
        
        strokeColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
