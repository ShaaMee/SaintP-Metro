//
//  StationButton.swift
//  SaintP Metro
//
//  Created by user on 11.08.2021.
//

import UIKit

@IBDesignable
class StationButton: UIButton {
  
  override func draw(_ rect: CGRect) {
    self.layer.cornerRadius = self.bounds.width / 2
    self.layer.masksToBounds = true
  }
}
