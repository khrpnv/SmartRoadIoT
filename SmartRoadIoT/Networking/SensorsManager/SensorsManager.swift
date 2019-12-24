//
//  SensorsManager.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SensorsManager {
  weak var delegate: SensorsManagerOutput?
  
  init(delegate: SensorsManagerOutput) {
    self.delegate = delegate
  }
  
  func changeSensorState(sensorId: String, prevState: Bool) {
    let url = "\(Const.baseUrl)/sensors/update/\(sensorId)?state=\(!prevState)"
    Alamofire.request(url, method: .post, parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseString { response in
        if response.result.isSuccess {
          self.delegate?.stateDidChanged()
        } else {
          if let responseData = response.data {
            let jsonResponse = try? JSON(data: responseData)
            self.delegate?.didGetErrors(jsonResponse?["reason"].stringValue)
          }
        }
    }
  }
}
