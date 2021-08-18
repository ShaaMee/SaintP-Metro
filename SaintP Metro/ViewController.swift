//
//  ViewController.swift
//  SaintP Metro
//
//  Created by user on 09.08.2021.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var showDetailsButton: UIButton!
  @IBOutlet weak var resetRouteButton: UIButton!
  @IBOutlet weak var mapView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var fromStationButton: UIButton!
  @IBOutlet weak var toStationButton: UIButton!
  @IBOutlet weak var routeTimeLabel: UILabel!
  @IBOutlet weak var transfersNumberLabel: UILabel!
  
  private var buttonDiameter: CGFloat {
    let side = min(self.view.layer.frame.width, self.view.layer.frame.height)
    return side / 40
  }
  
  let spbMetro = MetroGraph()

  private var route = [Station]()
  private var routeEdges = [Edge]()
  
  private var numberOfTransfers: Int {
    var counter = 0
    guard !route.isEmpty else { return 0 }
    for (index, station) in route.enumerated() {
      guard route.indices.contains(index + 1) else { return counter }
      if station.button.color != route[index + 1].button.color {
        counter += 1
      }
    }
    return counter
  }
  
  private var transfersText: String {
    let strNumberOfTransfers = String(numberOfTransfers)
    switch strNumberOfTransfers.last {
    case "1": return "\(numberOfTransfers) пересадка"
    case "2", "3", "4": return "\(numberOfTransfers) пересадки"
    case "0": if numberOfTransfers == 0 {
      return "Без пересадок"
    } else { return "\(numberOfTransfers) пересадок"}
    default: return "\(numberOfTransfers) пересадок"
    }
  }
  
  private var fromStation: Station?
  private var toStation: Station?
  private var overlayView: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self
    scrollView.decelerationRate = .fast
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    routeTimeLabel.text = nil
    transfersNumberLabel.text = nil
    
    let scrollViewSize = scrollView.bounds.size
    let mapViewSize = mapView.bounds.size
    
    let xScale = scrollViewSize.width / mapViewSize.width
    let yScale = scrollViewSize.height / mapViewSize.height
    let minScale = min(xScale, yScale)
    
    scrollView.minimumZoomScale = minScale
    scrollView.maximumZoomScale = 3
    
    toStationButton.layer.cornerRadius = fromStationButton.frame.size.height / 4
    showDetailsButton.layer.cornerRadius = showDetailsButton.bounds.height / 4
    showDetailsButton.isHidden = true
    resetRouteButton.layer.cornerRadius = showDetailsButton.layer.cornerRadius
    
    for button in [fromStationButton, toStationButton] {
      button?.layer.cornerRadius = fromStationButton.frame.size.height / 4
      button?.layer.borderWidth = 1
      button?.layer.borderColor = UIColor.darkGray.cgColor
    }
  
    StationsCreator.shared.createStationsFor(metroGraph: spbMetro, inViewController: self, withButtonDiameter: buttonDiameter)

    for edge in spbMetro.edges {
      let edgeView = BezierLine(edge: edge, view: self.view)
      mapView.addSubview(edgeView)
    }
    
    for station in spbMetro.allVertices {
      mapView.addSubview(station.button)
    }
    
    for station in spbMetro.allVertices {
      mapView.addSubview(station.button.label)
    }
  }

  @objc func stationButtonTapped(sender: StationButton?, isFromSearch: Bool = false) {
    
    switch (fromStation, toStation) {
    case (nil, nil):
      showDetailsButton.isHidden = true
      fromStation = sender?.station
      sender?.largeCircle()
      updateRouteLabels()
      
    case (nil, _):
      if sender?.station == toStation {
        showDetailsButton.isHidden = true
        fromStation = toStation
        toStation = nil
      } else {
        fromStation = sender?.station
        sender?.largeCircle()

        if fromStation != nil && toStation != nil {
          calculatePath()
        }
      }
      updateRouteLabels()
      
    case (_, nil):
      if sender?.station == fromStation {
        showDetailsButton.isHidden = true
        toStation = fromStation
        fromStation = nil
      } else {
        toStation = sender?.station
        sender?.largeCircle()

        if fromStation != nil && toStation != nil {
          calculatePath()
        }
      }
      updateRouteLabels()
      
    default:
      guard let overlayView = overlayView else { return }
      overlayView.removeFromSuperview()
      clearTimeAndTransfersLabel()
      showDetailsButton.isHidden = true
      fromStation?.button.smallCircle(buttonDiameter: buttonDiameter)
      toStation?.button.smallCircle(buttonDiameter: buttonDiameter)
      sender?.largeCircle()
      fromStation = sender?.station
      toStation = nil
      updateRouteLabels()
    }
  }
  
  func updateRouteLabels() {
    
    if fromStation != nil {
      fromStationButton.setTitle(fromStation?.name, for: .normal)
      fromStationButton.tintColor = fromStation?.button.color
      fromStationButton.setTitleColor(.black, for: .normal)
    } else {
      fromStationButton.setTitle("Откуда", for: .normal)
      fromStationButton.tintColor = .darkGray
      fromStationButton.setTitleColor(.darkGray, for: .normal)
    }
    
    if toStation != nil {
      toStationButton.setTitle(toStation?.name, for: .normal)
      toStationButton.tintColor = toStation?.button.color
      toStationButton.setTitleColor(.black, for: .normal)
    } else {
      toStationButton.setTitle("Куда", for: .normal)
      toStationButton.tintColor = .darkGray
      toStationButton.setTitleColor(.darkGray, for: .normal)
    }
  }
  
  func calculatePath(){
    DispatchQueue.global(qos: .background).async { [weak self] in
      let result = self?.spbMetro.findShortestPath(between: (self?.fromStation)!, and: (self?.toStation)!) ?? ([],[])
      self?.route = result.0
      self?.routeEdges = result.1
      DispatchQueue.main.async { [weak self] in
        self?.drawRoute()
        self?.showDetailsButton.isHidden = false
        self?.routeTimeLabel.text = "\((self?.toStation)!.shortestDistanceFromStart) мин"
        self?.transfersNumberLabel.text = self?.transfersText
        self?.scaleMapToRoute()
      }
    }
  }
  
  func drawRoute(){
    if overlayView != nil {
      overlayView?.removeFromSuperview()
    }
    
    overlayView = PassthroughView(frame: CGRect(x: -25, y: -25, width: view.frame.size.width + 50, height: view.frame.size.height + 50))
    guard let overlayView = overlayView else { return }
    
    overlayView.backgroundColor = .white
    overlayView.layer.opacity = 0.8
    overlayView.isUserInteractionEnabled = true
    mapView.addSubview(overlayView)
    
    for edge in routeEdges {
      if let edgeView = edge.edgeView {
        edgeView.isUserInteractionEnabled = false
        mapView.addSubview(edgeView)
      }
    }
    
    for station in route {
      mapView.addSubview(station.button)
      mapView.addSubview(station.button.label)
    }
  }
  
  @IBAction func showDetails(_ sender: UIButton) {
  }
  
  @IBAction func resetRoute(_ sender: UIButton) {
    overlayView?.removeFromSuperview()
    fromStation?.button.smallCircle(buttonDiameter: buttonDiameter)
    toStation?.button.smallCircle(buttonDiameter: buttonDiameter)
    fromStation = nil
    toStation = nil
    showDetailsButton.isHidden = true
    updateRouteLabels()
    clearTimeAndTransfersLabel()
    scrollView.zoom(to: mapView.bounds, animated: true)
  }
  
  func clearTimeAndTransfersLabel(){
    routeTimeLabel.text = nil
    transfersNumberLabel.text = nil
  }
  
  @IBAction func switchStations(_ sender: UIButton) {
    swap(&fromStation, &toStation)
    updateRouteLabels()
    
    if fromStation != nil && toStation != nil {
      calculatePath()
    }
  }
  
  @IBAction func searchForStation(_ sender: UIButton) {
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "showRoute"{
      guard let destinationVC = segue.destination as? DetailsTableViewController else { return }
      destinationVC.route = self.route
      destinationVC.routeEdges = self.routeEdges
      destinationVC.numberOfTransfers = self.numberOfTransfers
      destinationVC.transfersText = self.transfersText
    }
    
    if segue.identifier == "showSearchView" {
      guard let destinationVC = segue.destination as? SearchStationTableViewController else { return }
      var allStations = [Station]()
      spbMetro.allVertices.forEach { station in
        allStations.append(station)
      }
      destinationVC.allStations = allStations.sorted{ $0.name < $1.name }
      destinationVC.buttonTapped = sender as? UIButton
      destinationVC.delegate = self
    }
  }
  
  func scaleMapToRoute(){
    var minX: CGFloat = CGFloat(Int.max)
    var minY: CGFloat = CGFloat(Int.max)
    var maxX: CGFloat = CGFloat(Int.min)
    var maxY: CGFloat = CGFloat(Int.min)

    for station in route {
      minX = min(minX, min(station.button.frame.minX, station.button.label.frame.minX))
      minY = min(minY, min(station.button.frame.minY, station.button.label.frame.minY))
      maxX = max(maxX, max(station.button.frame.maxX, station.button.label.frame.maxX))
      maxY = max(maxY, max(station.button.frame.maxY, station.button.label.frame.maxY))
    }
    
    scrollView.zoom(to: CGRect(x: minX - 10, y: minY - 10, width: maxX - minX + 20, height: maxY - minY + 20), animated: true)
  }
}

extension ViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return mapView
  }
}

extension ViewController: SearchStationTableViewDelegate {
  func receiveSearchResult(station: Station, button: UIButton){
    if fromStation != nil && button == fromStationButton {
      
      fromStation?.button.smallCircle(buttonDiameter: buttonDiameter)
        fromStation = nil
        stationButtonTapped(sender: station.button)
    } else if toStationButton != nil && button == toStationButton {
      toStation?.button.smallCircle(buttonDiameter: buttonDiameter)
        toStation = nil
        stationButtonTapped(sender: station.button)
    } else {
      stationButtonTapped(sender: station.button)
    }
  }
}
