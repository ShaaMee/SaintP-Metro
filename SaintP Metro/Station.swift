//
//  Station.swift
//  SaintP Metro
//
//  Created by user on 12.08.2021.
//

import Foundation
import  UIKit

class Station: Hashable {
  var name: String
  var lineNumber: Int
  var edges: [Edge] = []
  var button = StationButton()
  var shortestDistanceFromStart = Int.max
  var previousVertex: Station?
  
  init(name: String, lineNumber: Int) {
    self.name = name
    self.lineNumber = lineNumber
  }
  
  static func == (lhs: Station, rhs: Station) -> Bool {
    return lhs.name == rhs.name
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
}
