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
  var numberOfTransfers = 0
  var transfersText: String = ""
  
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
