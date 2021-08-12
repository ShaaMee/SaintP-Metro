//
//  StationButton.swift
//  SaintP Metro
//
//  Created by user on 11.08.2021.
//

import UIKit


class StationButton: UIButton {
  
  var label = UILabel()
  weak var station: Station?
  
  override func draw(_ rect: CGRect) {
    self.layer.cornerRadius = self.bounds.width / 2
    self.layer.masksToBounds = true
  }
}
