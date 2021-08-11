//
//  ViewController.swift
//  SaintP Metro
//
//  Created by user on 09.08.2021.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var mapView: UIView!
  private let maxZoom: CGFloat = 3
  
  var mapViewMaxWidth: CGFloat {
    return mapView.layer.frame.width * maxZoom
  }
  
  var mapViewMaxHeight: CGFloat {
    return mapView.layer.frame.height * maxZoom
  }
  
  var pinchGestureRecognizer = UIPinchGestureRecognizer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.isUserInteractionEnabled = true
    mapView.isMultipleTouchEnabled = true
    
    mapView.addGestureRecognizer(pinchGestureRecognizer)
    pinchGestureRecognizer.addTarget(self, action: #selector(pinchGesture))
    
    // Do any additional setup after loading the view.
  }
  
  @objc func pinchGesture(){
    guard let gestureView = pinchGestureRecognizer.view else { return }

      gestureView.transform = gestureView.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale)
    
      pinchGestureRecognizer.scale = 1
  }
  
  
}
