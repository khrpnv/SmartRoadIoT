//
//  ServiceTableViewCell.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureCell(with title: String) {
    nameLabel.text = title
  }
  
}
