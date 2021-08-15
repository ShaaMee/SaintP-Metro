//
//  Edge.swift
//  SaintP Metro
//
//  Created by user on 12.08.2021.
//

import UIKit

class Edge: Equatable {
  var vertex1: Station
  var vertex2: Station
  var weight: Int
  weak var edgeView: BezierLine?
  
  init (vertex1: Station, vertex2: Station, weight: Int) {
    self.vertex1 = vertex1
    self.vertex2 = vertex2
    self.weight = weight
  }
  
  static func == (lhs: Edge, rhs: Edge) -> Bool {
    if lhs.vertex1 == rhs.vertex1 && lhs.vertex2 == rhs.vertex2 && lhs.weight == rhs.weight && lhs.edgeView == rhs.edgeView {
      return true
    } else { return false }
  }
}
