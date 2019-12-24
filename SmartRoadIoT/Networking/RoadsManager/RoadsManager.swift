//
//  RoadsManager.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RoadsManager {
  private weak var delegate: RoadsManagerOutput?
  
  init(delegate: RoadsManagerOutput) {
    self.delegate = delegate
  }
  
  func getRoads() {
    let url = "\(Const.baseUrl)/roads"
    Alamofire.request(url).responseJSON { (response) in
      guard let value = response.result.value else { return }
      let jsonArray = JSON(value).arrayValue
      var roads: [Road] = []
      for object in jsonArray {
        roads.append(Road(object: object))
      }
      self.delegate?.didLoadedRoads(roads: roads)
    }
  }
  
  func getSensorsForRoad(id: String) {
    let url = "\(Const.baseUrl)/roads/\(id)/sensors"
    Alamofire.request(url).responseJSON { (response) in
      guard let value = response.result.value else { return }
      let jsonArray = JSON(value).arrayValue
      var roadSensors: [RoadSensor] = []
      for object in jsonArray {
        roadSensors.append(RoadSensor(object: object))
      }
      self.delegate?.didLoadedSensors(sensors: roadSensors)
    }
  }
}
