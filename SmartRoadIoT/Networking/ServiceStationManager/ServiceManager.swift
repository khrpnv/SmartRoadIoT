//
//  NetworkingManager.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServiceManager {
  
  weak var delegate: ServiceManagerOutput?
  
  init(delegate: ServiceManagerOutput) {
    self.delegate = delegate
  }
  
  func getAllStations() {
    let serviceTypesUrl = "\(Const.baseUrl)/service_types"
    Alamofire.request(serviceTypesUrl).responseJSON { (response) in
      guard let value = response.result.value else { return }
      var services: [String: [ServiceStation]] = [:]
      let jsonObject = JSON(value)
      let jsonArray = jsonObject.arrayValue
      for index in 0 ..< jsonArray.count {
        let type = ServiceType(object: jsonArray[index])
        var stations: [ServiceStation] = []
        let stationsUrl = "\(Const.baseUrl)/service_types/\(type.id)/services"
        Alamofire.request(stationsUrl).responseJSON { (stationsResponse) in
          guard let stationsValue = stationsResponse.result.value else { return }
          let stationsJson = JSON(stationsValue)
          let stationsArray = stationsJson.arrayValue
          for object in stationsArray {
            stations.append(ServiceStation(object: object))
          }
          services[type.typeName] = stations
          if Array(services.keys).count == jsonArray.count {
            self.delegate?.didLoadedAllServiceStations(services: services)
          }
        }
      }
    }
  }
  
  func getSensorsForStationWith(id: String) {
    let url = "\(Const.baseUrl)/service_stations/\(id)/sensors"
    var sensors: [Sensor] = []
    Alamofire.request(url).responseJSON { (response) in
      guard let value = response.result.value else { return }
      let jsonObject = JSON(value)
      let jsonArray = jsonObject.arrayValue
      for object in jsonArray {
        sensors.append(Sensor(object: object))
      }
      self.delegate?.didLoadedSensors(sensors: sensors)
    }
  }
}
