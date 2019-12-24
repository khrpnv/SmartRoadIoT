//
//  SensorTableViewCell.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

class SensorTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureWith(number: Int) {
    titleLabel.text = "Sensor #\(number)"
  }
}
