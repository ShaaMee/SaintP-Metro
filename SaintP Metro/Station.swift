//
//  Station.swift
//  SaintP Metro
//
//  Created by user on 12.08.2021.
//

import Foundation
import  UIKit

class Station: Hashable {
  var labelText: String
  var name: String {
    labelText.replacingOccurrences(of: "\n", with: " ")
  }
  var lineNumber: Int
  var edges: [Edge] = []
  var button = StationButton()
  var shortestDistanceFromStart = Int.max
  var previousVertex: Station?
  
  init(name: String, lineNumber: Int) {
    self.labelText = name
    self.lineNumber = lineNumber
  }
  
  static func == (lhs: Station, rhs: Station) -> Bool {
    return lhs.labelText == rhs.labelText
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(labelText)
  }
}
