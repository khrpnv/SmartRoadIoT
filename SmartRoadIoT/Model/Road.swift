//
//  Road.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Road {
  let id: String
  let address: String
  
  init(object: JSON) {
    self.id = object["id"].stringValue
    self.address = object["address"].stringValue
  }
}
