//
//  RoadsManagerOutput.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol RoadsManagerOutput: class {
  func didLoadedRoads(roads: [Road])
  func didLoadedSensors(sensors: [RoadSensor])
}
