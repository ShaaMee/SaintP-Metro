//
//  SearchStationTableViewCell.swift
//  SaintP Metro
//
//  Created by user on 17.08.2021.
//

import UIKit

class SearchStationTableViewCell: UITableViewCell {
  @IBOutlet weak var circleView: UIView!
  
  @IBOutlet weak var stationNameLabel: UILabel!
  
  override func layoutSubviews() {
    circleView.layer.cornerRadius = circleView.frame.size.width / 2
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
