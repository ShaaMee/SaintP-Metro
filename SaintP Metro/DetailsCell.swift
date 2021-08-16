//
//  DetailsCell.swift
//  SaintP Metro
//
//  Created by user on 13.08.2021.
//

import UIKit

class DetailsCell: UITableViewCell {

  @IBOutlet weak var stationNameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var largeCircleView: UIView!
  @IBOutlet weak var stationCircleView: UIView!
  @IBOutlet weak var fromStationView: UIView!
  @IBOutlet weak var toStationView: UIView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
