//
//  SearchStationTableViewController.swift
//  SaintP Metro
//
//  Created by user on 17.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchStationTableViewDelegate: class {
  func receiveSearchResult(station: Station, button: UIButton)
}

class SearchStationTableViewController: UITableViewController {
  
  @IBOutlet weak var searchTextField: UITextField!
  
  var allStations = [Station]()
  var searchResult = [Station]()
  var buttonTapped: UIButton?
  weak var delegate: SearchStationTableViewDelegate?
  let bag = DisposeBag()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.dataSource = nil
      searchTextField.becomeFirstResponder()
      
      let search = searchTextField.rx.text.orEmpty
        .flatMapLatest { [weak self] searchLine -> Observable<[Station]> in
          if searchLine == "" {
            return .just([])
          } else {
            return Observable.of(self?.allStations.filter{$0.name.lowercased().contains(searchLine.lowercased())} ?? [] )
          }
        }
      
      search.bind(to: tableView.rx.items(cellIdentifier: "showSearchView", cellType: SearchStationTableViewCell.self)) { (index, element, cell) in
        cell.stationNameLabel.text = element.name
        cell.circleView.backgroundColor = element.button.color
      }
      .disposed(by: bag)
      
      search.subscribe(onNext: { [weak self] stations in
        self?.searchResult = stations
      })
      .disposed(by: bag)
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let buttonTapped = buttonTapped else { return }
    delegate?.receiveSearchResult(station: searchResult[indexPath.row], button: buttonTapped)
    self.dismiss(animated: true, completion: nil)
  }
}
