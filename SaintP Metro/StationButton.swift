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
  var color: UIColor = .clear
  var smallCircleView: UIView?
  var buttonDiameter: CGFloat = 0
  var centerPoint: CGPoint {
    CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
  }
  
  override func layoutSubviews() {
    self.layer.cornerRadius = self.bounds.width / 2
    self.backgroundColor = .white
    self.layer.masksToBounds = true
    
    if smallCircleView != nil {
      smallCircleView?.removeFromSuperview()
    }

    let smallCircle = UIView(frame: CGRect(origin: self.bounds.origin,
                                           size: CGSize(width: self.frame.size.width * 0.8,
                                                        height: self.frame.size.height * 0.8)))
    smallCircle.center = centerPoint
    smallCircle.layer.cornerRadius = smallCircle.frame.size.width / 2
    smallCircle.backgroundColor = color
    smallCircle.isUserInteractionEnabled = false
    self.smallCircleView = smallCircle
    self.addSubview(smallCircle)
  }
  
  func largeCircle(){
    let circleCenter = self.center
    self.frame.size = CGSize(width: self.frame.size.width * 1.7, height: self.frame.size.width * 1.7)
    self.center = circleCenter
    self.layer.cornerRadius = self.frame.width / 2
    self.layoutSubviews()
  }
  
  func smallCircle(buttonDiameter: CGFloat){
    let circleCenter = self.center
    self.frame.size = CGSize(width: buttonDiameter, height: buttonDiameter)
    self.center = circleCenter
    self.layer.cornerRadius = self.frame.width / 2
    self.layoutSubviews()
  }
}
