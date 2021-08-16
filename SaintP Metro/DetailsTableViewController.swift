//
//  DetailsTableViewController.swift
//  SaintP Metro
//
//  Created by user on 13.08.2021.
//

import UIKit

class DetailsTableViewController: UITableViewController {
  var route = [Station]()
  var routeEdges = [Edge]()
  
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
  
  @IBOutlet weak var headerView: TableHeaderView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
      headerView.layer.cornerRadius = 10
      if !route.isEmpty {
        headerView.titleLabel.text = "\(route.last!.shortestDistanceFromStart) мин.  \(transfersText)"
      }
      
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return route.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as? DetailsCell else { return UITableViewCell()}
      
      cell.selectionStyle = .none
      cell.largeCircleView.layer.cornerRadius = cell.largeCircleView.frame.size.width / 2
      let color = route[indexPath.row].button.color
      cell.stationNameLabel.text = route[indexPath.row].name
      
      if routeEdges.indices.contains(indexPath.row) {
        if route[indexPath.row].button.color == route[indexPath.row + 1].button.color{
          cell.timeLabel.text = "\(routeEdges[indexPath.row].weight) мин."
        } else {
          cell.timeLabel.text = "Пересадка на линию \(route[indexPath.row + 1].lineNumber). (\(routeEdges[indexPath.row].weight) мин.)"
        }
      } else {
        cell.timeLabel.text = nil
      }
      
      
      cell.fromStationView.backgroundColor = route.indices.contains(indexPath.row - 1) ? color : .clear
      cell.toStationView.backgroundColor = route.indices.contains(indexPath.row + 1) ? color : .clear
      cell.stationCircleView.backgroundColor = color
      cell.stationCircleView.layer.cornerRadius = cell.stationCircleView.frame.size.width / 2

        return cell
    }
}
