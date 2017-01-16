//
//  Pathfinder.swift
//  Dijkstra
//
//  Created by Xander Lewis on 15/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import Foundation
import SpriteKit

class VertexSet {
    var vertices: Set<Vertex> = []
    
    init(vertices: Set<Vertex>) {
        self.vertices = vertices
    }
    
    func findShortestPath(from start: Vertex, to end: Vertex) -> [Vertex] {
        let distances = findDistances(from: start, to: end)
        
        // Initialise path
        var path: [Vertex] = []
        
        // Start with end vertex
        var currentVertex = end
        
        // Add end vertex to path
        path.append(currentVertex)
        
        // Loop until back at start
        while !path.contains(start) {
            
            // If the neighbour's dist to start = current vertex's distance to start - current vertex's distance to neighbour...
            for (neighbour, distAway) in currentVertex.connections {
                if distances[neighbour]! == distances[currentVertex]! - distAway {
                    
                    // Add neighbour to path
                    path.append(neighbour)
                    
                    // Start considering neighbours of the next vertex
                    currentVertex = neighbour
                }
            }
        }
        
        // Return path (reversed because we backtracked)
        return path.reversed()
    }
    
    func findDistances(from start: Vertex, to end: Vertex) -> [Vertex: Int] {
        
        // Store initial unvisited vertices
        var unvisitedVertices = vertices
        
        // Store initial tentative distances (1000 for all apart from start which is 0)
        var tentativeDistances: Dictionary<Vertex, Int> = [:]
        for v in vertices {
            tentativeDistances[v] = 1000
        }
        tentativeDistances[start] = 0
        
        
        // Start with start node!
        var currentVertex = start
        
        while unvisitedVertices.contains(end) {
            
            // For each unvisited neighbour...
            for (neighbour, dist) in currentVertex.connections {
                if unvisitedVertices.contains(neighbour) {
                    
                    // If distance to vertex is less than current tentative distance, replace it
                    if tentativeDistances[currentVertex]! + dist < tentativeDistances[neighbour]! {
                        tentativeDistances[neighbour] = tentativeDistances[currentVertex]! + dist
                    }
                }
            }
            
            // Vertex has been visited
            unvisitedVertices.remove(currentVertex)
            
            // Set unvisited vertex with smallest tentative distance as current vertex
            
            var smallestDistance = 1000
            
            for vertex in unvisitedVertices {
                
                if tentativeDistances[vertex]! < smallestDistance {
                    smallestDistance = tentativeDistances[vertex]!
                    currentVertex = vertex
                }
            }
            
            for u in unvisitedVertices {
                print(u.id)
            }
        }
        
        return tentativeDistances
    }
}
