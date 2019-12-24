//
//  RoadSensorsManagerOutput.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol RoadSensorsManagerOutput: class {
  func didResetSensorsValue()
  func didChangeSensorsState()
  func didGetErrors(message: String?)
}
