//
//  RoadSensorsViewController.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

class RoadSensorsViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private var infoLabels: [UILabel]!
  @IBOutlet private weak var idLabel: UILabel!
  @IBOutlet private weak var isOverlappedLabel: UILabel!
  @IBOutlet private weak var changesAmountLabel: UILabel!
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
  
  private var roadSensorsManager: RoadSensorsManager?
  private var road: Road? = nil
  private let cellId = "sensorCell"
  private var timer: Timer?
  private var sensors: [RoadSensor] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  private var currentSensor: RoadSensor? = nil {
    didSet {
      hideLabels(isHidden: false)
      idLabel.text = currentSensor?.id
      isOverlappedLabel.text = String(currentSensor?.isOverlaped ?? false)
      changesAmountLabel.text = String(currentSensor?.amountOfStateChanges ?? 0)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = road?.address
    tableView.delegate = self
    tableView.dataSource = self
    hideLabels(isHidden: true)
    activityIndicator.startAnimating()
    roadSensorsManager = RoadSensorsManager(delegate: self)
    getData()
    setupReset()
  }
  
  func setRoad(road: Road) {
    self.road = road
  }
  
  @IBAction func resetPressed(_ sender: Any) {
    hideLabels(isHidden: true)
    guard let id = currentSensor?.id else { return }
    roadSensorsManager?.resetSensor(id: id)
  }
  
  @IBAction func changeState(_ sender: Any) {
    hideLabels(isHidden: true)
    guard let id = currentSensor?.id,
      let state = currentSensor?.isOverlaped else { return }
    roadSensorsManager?.updateSensor(id: id, state: !state)
  }
}

// MARK: - Private
private extension RoadSensorsViewController {
  func setupProximityMonitoring() {
    UIDevice.current.isProximityMonitoringEnabled = true
    UIApplication.shared.isIdleTimerDisabled = true
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(proximityStateDidChange),
                                           name: UIDevice.proximityStateDidChangeNotification,
                                           object: nil)
  }
  
  func hideLabels(isHidden: Bool) {
    infoLabels.forEach({ $0.isHidden = isHidden })
  }
  
  func getData() {
    let roadsManager = RoadsManager(delegate: self)
    guard let id = road?.id else { return }
    roadsManager.getSensorsForRoad(id: id)
  }
  
  func setupReset() {
    let calendar = Calendar.current
    let hours = calendar.component(.hour, from: Date())
    let minutes = calendar.component(.minute, from: Date())
    timer = Timer(fireAt: Date(),
                      interval: 60,
                      target: self,
                      selector: #selector(resetSensor),
                      userInfo: nil,
                      repeats: true)
    if hours == 9 && minutes == 0 {
      timer?.fire()
    }
  }
}

// MARK: - UITableViewDelegate
extension RoadSensorsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    currentSensor = sensors[indexPath.row]
  }
}

// MARK: - UITableViewDataSource
extension RoadSensorsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sensors.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    cell.textLabel?.text = "Sensor #\(indexPath.row + 1)"
    return cell
  }
}

// MARK: - RoadsManagerOutput
extension RoadSensorsViewController: RoadsManagerOutput {
  func didLoadedRoads(roads: [Road]) { return }
  
  func didLoadedSensors(sensors: [RoadSensor]) {
    activityIndicator.stopAnimating()
    self.sensors = sensors
  }
}

// MARK: - RoadSensorsManagerOutput
extension RoadSensorsViewController: RoadSensorsManagerOutput {
  func didResetSensorsValue() {
    print("Did reset value")
    getData()
  }
  
  func didChangeSensorsState() {
    print("Did change state")
    getData()
  }
  
  func didGetErrors(message: String?) {
    print(message ?? "")
  }
}

// MARK: - Handlers
extension RoadSensorsViewController {
  @objc func proximityStateDidChange() {
    let state = UIDevice.current.proximityState
    guard let id = currentSensor?.id else { return }
    roadSensorsManager?.updateSensor(id: id, state: state)
  }
  
  @objc func resetSensor() {
    let calendar = Calendar.current
    let hours = calendar.component(.hour, from: Date())
    let minutes = calendar.component(.minute, from: Date())
    if hours == 24 && minutes == 0 {
      timer?.invalidate()
    }
    guard let id = currentSensor?.id else { return }
    roadSensorsManager?.resetSensor(id: id)
  }
}
