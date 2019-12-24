//
//  NetworkingManagerDelegate.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
protocol ServiceManagerOutput: class {
  func didLoadedAllServiceStations(services: [String: [ServiceStation]])
  func didLoadedSensors(sensors: [Sensor])
}
