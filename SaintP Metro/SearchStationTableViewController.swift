//
//  SearchStationTableViewController.swift
//  SaintP Metro
//
//  Created by user on 17.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SearchStationTableViewController: UITableViewController {
  
  @IBOutlet weak var searchTextField: UITextField!
  
  var allStations = [Station]()
  let bag = DisposeBag()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.dataSource = nil
      
      let search = searchTextField.rx.text.orEmpty
        .flatMapLatest { (searchLine) -> Observable<[Station]> in
          if searchLine == "" {
            return .just([])
          } else {
            return Observable.of(self.allStations.filter{$0.name.lowercased().contains(searchLine.lowercased())} )
          }
        }
      
      search.bind(to: tableView.rx.items(cellIdentifier: "showSearchView", cellType: SearchStationTableViewCell.self)) { (index, element, cell) in
        cell.textLabel?.text = element.name
      }
      .disposed(by: bag)
    }
}
