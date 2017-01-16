//
//  GameScene.swift
//  Dijkstra
//
//  Created by Xander Lewis on 14/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import SpriteKit
import GameplayKit

class Scene: SKScene {
    
    // Gesture recognizers
    var tapRec: UITapGestureRecognizer!
    var longPressRec: UILongPressGestureRecognizer!
    
    var vertexBeingPulled: Vertex? = nil
    
    var pullingEdge: PullingEdge? = nil
    
    var startVertex: Vertex? {
        didSet {
            // Swap over to new start vertex
            oldValue?.isStartVertex = false
            startVertex?.isStartVertex = true
            
            startVertex?.spin()
        }
    }
    var endVertex: Vertex? {
        didSet {
            // Swap over to new end vertex
            oldValue?.isEndVertex = false
            endVertex?.isEndVertex = true
            
            endVertex?.spin()
        }
    }
    
    // MARK: - Initial Setup
    
    override func didMove(to view: SKView) {
        setUpGestureRecognizers()
        
        backgroundColor = UIColor(white: 0.85, alpha: 1.0)
    }
    
    // MARK: - Clear screen
    
    func clearGraph() {
        
        self.pullingEdge = nil
        self.startVertex = nil
        self.endVertex = nil
        
        Vertex.ids = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
                      "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        // Drop off screen
        for node in children {
            
            // Random x and y within range
            var x = CGFloat(arc4random_uniform(500)) + 500
            var y = CGFloat(arc4random_uniform(500)) + 500
            
            if arc4random_uniform(2) == 0 {
                x = -x
            }
            
            if arc4random_uniform(2) == 0 {
                y = -y
            }
            
            let drop = SKAction.move(by: CGVector(dx: x, dy: y), duration: 0.8)
            
            node.run(drop) {
                // Remove node from scene
                
                node.removeFromParent()
            }
        }
    }
    
    // MARK: - Pathfinding
    
    func pathfind() {
        // Check that start and end actually exist and have neighbours
        if startVertex != nil && endVertex != nil {
            
            if !startVertex!.connections.isEmpty || !endVertex!.connections.isEmpty {
                
                let path = getVerticesAndFindPath()
                
                highlight(path: path)
            }
        }
    }
    
    func getVerticesAndFindPath() -> [Vertex] {
        
        var path: [Vertex] = []
        
        var vertices: Set<Vertex> = []
                
        // Find vertices
        enumerateChildNodes(withName: "vertex") { (node, stop) in
            let vertex = node as! Vertex
            vertices.insert(vertex)
        }
                
        // Find shortest path through vertex set
        let vertexSet = VertexSet(vertices: vertices)
        path = vertexSet.findShortestPath(from: startVertex!, to: endVertex!)
    
        return path
    }
    
    func highlight(path: [Vertex]) {
        
        // Make sure all edges are unhighlited
        enumerateChildNodes(withName: "edge", using: { (node, stop) in
            let edge = node as! Edge
            edge.highlighted = false
        })
        
        // Show user the path (highlight the edges connecting the vertex path)
        for i in 0..<path.count-1 {
            enumerateChildNodes(withName: "edge", using: { (node, stop) in
                let edge = node as! Edge
                
                if edge.startVertex == path[i] && edge.endVertex == path[i+1]
                    || edge.endVertex == path[i] && edge.startVertex == path[i+1] {
                    edge.highlighted = true
                    return
                }
            })
        }
    }
    
    // MARK: - Gesture Responses
    
    func tappedScene(sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            
            // Get location of tap
            let tapLocation = sender.location(in: view)
            
            for node in nodes(at: convertPoint(fromView: tapLocation)) {
                if node is Vertex {
                    // User has tapped on an existing vertex...
                    
                    let tappedVertex = node as! Vertex
                    
                    tappedVertex.bounce()
                    
                    // Ask user whether vertex should be start or end
                    let pop = UIAlertController(title: "Should this vertex be the start or end?", message: nil, preferredStyle: .actionSheet)
                    
                    pop.addAction(UIAlertAction(title: "Start", style: .default, handler: { (action) in
                        self.startVertex = tappedVertex
                    }))
                    
                    pop.addAction(UIAlertAction(title: "End", style: .default, handler: { (action) in
                        self.endVertex = tappedVertex
                    }))
                    
                    pop.addAction(UIAlertAction(title: "Never mind!", style: .cancel, handler: nil))
                    
                    view?.window?.rootViewController?.present(pop, animated: true, completion: nil)
                    
                    if let ppc = pop.popoverPresentationController {
                        ppc.sourceView = view!
                        ppc.sourceRect = tappedVertex.frame
                    }
                    
                    return
                }
            }
            
            // If user didn't tap on an existing vertex...
            
            // Create a vertex at location
            if let vertex = Vertex(position: convertPoint(fromView: tapLocation)) {
                self.addChild(vertex)
                
                vertex.bounce()
                
            } else {
                // Couldn't create a new vertex!
                let alert = UIAlertController(title: "Woah!", message: "You've already made 26 vertices. No more for now.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Fine... 🙄", style: .default, handler: nil))
                
                // (This will only work if there is one view controller)
                view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func longPressedScene(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            
            // Find vertex that user is interacting with
            for node in nodes(at: convertPoint(fromView: sender.location(in: view))) {
                if node is Vertex {
                    
                    let vertex = node as! Vertex
                    
                    vertexBeingPulled = vertex
                    
                    vertex.liftUp()
                    vertex.bounce()
                    
                    pullingEdge?.isHidden = false
                }
            }
        }
        
        if sender.state == .changed {
            if let vertex = vertexBeingPulled {
                
                // Draw line from vertex to user's touch location
                let start = vertex.position
                let end = convertPoint(fromView: sender.location(in: view))
                
                if let edge = pullingEdge {
                    edge.start = start
                    edge.end = end
                } else {
                    pullingEdge = PullingEdge(start: start, end: end)
                    self.addChild(pullingEdge!)
                }
            }
        }
        
        if sender.state == .ended {
            if let vertex = vertexBeingPulled {
                
                // Find vertex that user is on top of
                for node in nodes(at: convertPoint(fromView: sender.location(in: view))) {
                    if node is Vertex {
                        let endVertex = node as! Vertex
                        
                        // If end vertex isn't the one the user started on...
                        if endVertex != vertex {
                            
                            // Get distance of edge
                            let distance = Int(arc4random_uniform(9)) + 1
                            
                            // Connect vertex to end vertex
                            vertex.connectInBothDirections(toVertex: endVertex, withDistance: distance)
                            
                            endVertex.bounce()
                            
                            // TEST CODE FOR DRAWING EDGE
                            let edge = Edge(startVertex: vertex, endVertex: endVertex)
                            self.addChild(edge)
                            
                            // Randomise distance of edge (between 1 and 10)
                            edge.setDistance(to: distance)

                        } else {
                            // Ended on start vertex, do nothing.
                        }
                    }
                }
                
                vertex.putDown()
                
                vertexBeingPulled = nil
                
                pullingEdge?.disappear()
            }
            
        }
    }
    
    func setUpGestureRecognizers() {
        tapRec = UITapGestureRecognizer(target: self, action: #selector(tappedScene))
        longPressRec = UILongPressGestureRecognizer(target: self, action: #selector(longPressedScene))
        
        longPressRec.minimumPressDuration = 0.1
        
        view?.addGestureRecognizer(tapRec)
        view?.addGestureRecognizer(longPressRec)
    }
}
