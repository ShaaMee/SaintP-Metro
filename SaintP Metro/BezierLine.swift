//
//  BezierLine.swift
//  SaintP Metro
//
//  Created by user on 12.08.2021.
//

import UIKit

class BezierLine: UIView {
  var edge: Edge
  let path = UIBezierPath()
  weak var view: UIView?
  
  init(edge: Edge, view: UIView) {
    self.edge = edge
    self.view = view
    super.init(frame: .zero)
    self.frame = view.frame
    self.backgroundColor = .clear

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    guard edge.vertex1.lineNumber == edge.vertex2.lineNumber else { return }
    
    path.move(to: edge.vertex1.button.center)
    path.addLine(to: edge.vertex2.button.center)
    let color = edge.vertex1.button.color
    color.setStroke()
    path.lineWidth = edge.vertex1.button.buttonDiameter * 0.4
    path.stroke()
    self.edge.edgeView = self
  }
}
