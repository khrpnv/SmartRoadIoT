//
//  ServiceStation.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ServiceStation {
  var id: String?
  var name: String
  var description: String
  var latitude: Double
  var longtitude: Double
  var type: Int
  
  init(object: JSON) {
    self.id = object["id"].stringValue
    self.name = object["name"].stringValue
    self.description = object["description"].stringValue
    self.latitude = object["latitude"].doubleValue
    self.longtitude = object["longtitude"].doubleValue
    self.type = object["type"].intValue
  }
}
