//
//  Midpoint.swift
//  Dijkstra
//
//  Created by Xander Lewis on 14/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import Foundation
import SpriteKit

extension CGPoint {
    static func midpoint(ofPoint p1: CGPoint, andPoint p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
}
