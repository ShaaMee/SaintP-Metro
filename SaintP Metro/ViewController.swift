//
//  ViewController.swift
//  SaintP Metro
//
//  Created by user on 09.08.2021.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var mapView: UIView!
  
  var pinchGestureRecognizer = UIPinchGestureRecognizer()
  var panGestureRecognizer = UIPanGestureRecognizer()
  var initialCenter = CGPoint()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.isUserInteractionEnabled = true
    mapView.isMultipleTouchEnabled = true
    
    mapView.addGestureRecognizer(pinchGestureRecognizer)
    mapView.addGestureRecognizer(panGestureRecognizer)
    pinchGestureRecognizer.addTarget(self, action: #selector(pinchGesture))
    panGestureRecognizer.addTarget(self, action: #selector(panGesture))
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func pinchGesture(){
    guard let gestureView = pinchGestureRecognizer.view else { return }

      gestureView.transform = gestureView.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale)
    
      pinchGestureRecognizer.scale = 1
  }
  
  @IBAction func panGesture(){
    guard let gestureView = panGestureRecognizer.view else { return }
    
    let translation = panGestureRecognizer.translation(in: gestureView.superview)

    if panGestureRecognizer.state == .began {
          self.initialCenter = gestureView.center
       }
    
    let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
    gestureView.center = newCenter
  }
  
  
}
