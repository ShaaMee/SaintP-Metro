//
//  DetailsTableViewController.swift
//  SaintP Metro
//
//  Created by user on 13.08.2021.
//

import UIKit

class DetailsTableViewController: UITableViewController {
  var route = [Station]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return route.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
      cell.selectionStyle = .none
      cell.textLabel?.text = route[indexPath.row].name
        return cell
    }

}
