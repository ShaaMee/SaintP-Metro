//
//  MetroGraph.swift
//  Homework_7
//
//  Created by user on 17.07.2021.
//

import Foundation

class MetroGraph {
  var allVertices = Set<Station>()
  var edges: [Edge] = []
  
  func addNewVertex(name: String, lineNumber: Int) -> Station {
    let vertex = Station(name: name, lineNumber: lineNumber)
    allVertices.insert(vertex)
    return vertex
  }
  
  func addEdgeBetween(_ fromVertex: Station, and toVertex: Station, withWeight weight: Int){
    let edge = Edge(vertex1: fromVertex, vertex2: toVertex, weight: weight)
    edge.vertex1.edges.append(edge)
    edge.vertex2.edges.append(edge)
    edges.append(edge)
  }
  
  func findShortestPath(between startVertex: Station, and finishVertex: Station) {
    
    var unvisitedVertices = allVertices
    startVertex.shortestDistanceFromStart = 0
    var currentVertex = startVertex
    
    while !unvisitedVertices.isEmpty {
      for edge in currentVertex.edges {
        for edgeVertex in [edge.vertex1, edge.vertex2] {
          
          if edgeVertex.name != currentVertex.name && unvisitedVertices.contains(edgeVertex) {
            if edgeVertex.shortestDistanceFromStart > currentVertex.shortestDistanceFromStart + edge.weight {
              edgeVertex.shortestDistanceFromStart = currentVertex.shortestDistanceFromStart + edge.weight
              edgeVertex.previousVertex = currentVertex
            }
          }
        }
      }
      unvisitedVertices.remove(currentVertex)
      
      let minVertex = unvisitedVertices.min {
        $0.shortestDistanceFromStart < $1.shortestDistanceFromStart
      }
      
      if minVertex != nil {
        currentVertex = minVertex!
      }
    }
    
    var prevVertex = finishVertex.previousVertex
    var route = [Station]()
    route.append(finishVertex)
    
    while prevVertex != nil {
      route.insert(prevVertex!, at: 0)
      prevVertex = prevVertex?.previousVertex
    }
    
    if finishVertex.shortestDistanceFromStart == Int.max {
      print("Can't build a route between \(startVertex.name) and \(finishVertex.name).")
    } else {
      print("The fastest route from \(startVertex.name) to \(finishVertex.name) is \(finishVertex.shortestDistanceFromStart) minutes long: ", terminator: "")
      
      for i in route {
        print(i.name, terminator: "")
        
        if i.name != finishVertex.name {
          print(" -> ", terminator: "")
        } else { print("") }
      }
    }
    
  }
}
