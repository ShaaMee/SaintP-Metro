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
  
  func findShortestPath(between startVertex: Station, and finishVertex: Station) -> ([Station], [Edge]) {
    
    for station in allVertices {
      station.previousVertex = nil
      station.shortestDistanceFromStart = Int.max
    }
    
    var unvisitedVertices = allVertices
    startVertex.shortestDistanceFromStart = 0
    var currentVertex = startVertex
    
    while !unvisitedVertices.isEmpty {
      for edge in currentVertex.edges {
        for edgeVertex in [edge.vertex1, edge.vertex2] {
          
          if edgeVertex.labelText != currentVertex.labelText && unvisitedVertices.contains(edgeVertex) {
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
      
      if let minVertex = minVertex {
        currentVertex = minVertex
      }
    }
    
    var prevVertex = finishVertex.previousVertex
    var route = [Station]()
    route.append(finishVertex)
    
    while prevVertex != nil {
      if let prevVertex = prevVertex {
        route.insert(prevVertex, at: 0)
      }
      prevVertex = prevVertex?.previousVertex
    }
    
    let reversedRoute = route.reversed()
    var reversedRouteEdges = [Edge]()
    
    for station in reversedRoute {
      for edge in station.edges {
        if edge.vertex1 == station.previousVertex || edge.vertex2 == station.previousVertex {
          reversedRouteEdges.append(edge)
        }
      }
    }
    
    return (route, reversedRouteEdges.reversed())
  }
}
