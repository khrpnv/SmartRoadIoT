//
//  Sensor.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Sensor {
  let id: String
  var isEmptyPlace: Bool
  let ownerId: String
  
  init(object: JSON) {
    self.id = object["id"].stringValue
    self.isEmptyPlace = object["isEmptyPlace"].boolValue
    self.ownerId = object["ownerId"].stringValue
  }
  
  func convertToDictionary() -> [String: Any] {
    return [
      "id": self.id,
      "isEmptyPlace": self.isEmptyPlace,
      "ownerId": self.ownerId
    ]
  }
}
