//
//  RoadSensor.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RoadSensor {
  let id: String
  let isOverlaped: Bool
  let roadId: String
  let amountOfStateChanges: Int
  
  init(object: JSON) {
    self.id = object["id"].stringValue
    self.isOverlaped = object["isOverlaped"].boolValue
    self.roadId = object["roadId"].stringValue
    self.amountOfStateChanges = object["amountOfStateChanges"].intValue
  }
}
