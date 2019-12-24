//
//  SensorsManagerOutput.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol SensorsManagerOutput: class {
  func stateDidChanged()
  func didGetErrors(_ message: String?)
}
