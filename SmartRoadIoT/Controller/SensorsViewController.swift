//
//  SensorsViewController.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

class SensorsViewController: UIViewController {
  
  private let cellId = "sensorCell"
  private var station: ServiceStation? = nil
  private var sensors: [Sensor] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  private var currentSensor: Sensor? = nil {
    didSet {
      infoLabels.forEach { $0.isHidden = false }
      guard
        let id = currentSensor?.id,
        let state = currentSensor?.isEmptyPlace
        else {
          return
      }
      idValueLabel.text = id
      stateLabel.text = String(state)
    }
  }
  private var deviceIsOverlapped: Bool = false
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet private var infoLabels: [UILabel]!
  @IBOutlet private weak var idValueLabel: UILabel!
  @IBOutlet private weak var stateLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupProximityMonitoring()
    self.title = station?.name
    tableView.delegate = self
    tableView.dataSource = self
    activityIndicator.startAnimating()
    getSensorsInfo()
  }
  
  func setStation(station: ServiceStation) {
    self.station = station
  }
  
  
  @IBAction func changeStatePressed(_ sender: Any) {
    neededToChangeState(prevState: currentSensor?.isEmptyPlace ?? false)
  }
}

// MARK: - Private
private extension SensorsViewController {
  func getSensorsInfo() {
    let serviceManager = ServiceManager(delegate: self)
    if let id = station?.id {
      serviceManager.getSensorsForStationWith(id: id)
    }
    infoLabels.forEach { $0.isHidden = true }
  }
  
  func neededToChangeState(prevState: Bool) {
    let sensorsManager = SensorsManager(delegate: self)
    guard let sensor = currentSensor else { return }
    sensorsManager.changeSensorState(sensorId: sensor.id, prevState: prevState)
  }
  
  func setupProximityMonitoring() {
    UIDevice.current.isProximityMonitoringEnabled = true
    UIApplication.shared.isIdleTimerDisabled = true
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(proximityDidChange),
                                           name: UIDevice.proximityStateDidChangeNotification,
                                           object: nil)
  }
}

// MARK: - UITableViewDelegate
extension SensorsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sensor = sensors[indexPath.row]
    currentSensor = sensor
  }
}

// MARK: - UITableViewDataSource
extension SensorsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sensors.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SensorTableViewCell else {
      fatalError()
    }
    cell.configureWith(number: indexPath.row + 1)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

// MARK: - ServiceManagerOutput
extension SensorsViewController: ServiceManagerOutput {
  func didLoadedAllServiceStations(services: [String : [ServiceStation]]) { return }
  
  func didLoadedSensors(sensors: [Sensor]) {
    activityIndicator.stopAnimating()
    self.sensors = sensors
  }
}

// MARK: - SensorsManagerOutput
extension SensorsViewController: SensorsManagerOutput {
  func stateDidChanged() {
    print("Done, new state: deviceIsOverlapped = \(deviceIsOverlapped)")
    getSensorsInfo()
  }
  
  func didGetErrors(_ message: String?) {
    print(message ?? "Error")
  }
}

// MARK: - Proximity handler
extension SensorsViewController {
  @objc func proximityDidChange() {
    deviceIsOverlapped = UIDevice.current.proximityState
    if deviceIsOverlapped {
      DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
        if self?.deviceIsOverlapped ?? false {
          self?.neededToChangeState(prevState: self?.deviceIsOverlapped ?? true)
        }
      }
    } else {
      deviceIsOverlapped = false
      neededToChangeState(prevState: deviceIsOverlapped)
    }
  }
}
