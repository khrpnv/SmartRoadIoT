//
//  RoadSensorsManager.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RoadSensorsManager {
  private weak var delegate: RoadSensorsManagerOutput?
  
  init(delegate: RoadSensorsManagerOutput) {
    self.delegate = delegate
  }
  
  func updateSensor(id: String, state: Bool) {
    let url = "\(Const.baseUrl)/road_sensors/update/\(id)?state=\(state)"
    Alamofire.request(url, method: .post, parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseString { response in
        if response.result.isSuccess {
          self.delegate?.didChangeSensorsState()
        } else {
          if let responseData = response.data {
            let jsonResponse = try? JSON(data: responseData)
            self.delegate?.didGetErrors(message: jsonResponse?["reason"].stringValue)
          }
        }
    }
  }
  
  func resetSensor(id: String) {
    let url = "\(Const.baseUrl)/road_sensors/reset/\(id)"
    Alamofire.request(url, method: .post, parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseString { response in
        if response.result.isSuccess {
          self.delegate?.didResetSensorsValue()
        } else {
          if let responseData = response.data {
            let jsonResponse = try? JSON(data: responseData)
            self.delegate?.didGetErrors(message: jsonResponse?["reason"].stringValue)
          }
        }
    }
  }
}
