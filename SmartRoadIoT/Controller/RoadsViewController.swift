//
//  RoadsViewController.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

class RoadsViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
  
  private let cellId = "roadCell"
  private var roads: [Road] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Roads"
    tableView.delegate = self
    tableView.dataSource = self
    activityIndicator.startAnimating()
    let roadsManager = RoadsManager(delegate: self)
    roadsManager.getRoads()
  }
  
  func presentScreen(road: Road) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let destVC: RoadSensorsViewController
    if #available(iOS 13.0, *) {
      destVC = storyboard.instantiateViewController(identifier: "RoadSensorsViewController")
    } else {
      destVC = storyboard.instantiateViewController(withIdentifier: "RoadSensorsViewController") as! RoadSensorsViewController
    }
    destVC.modalPresentationStyle = .fullScreen
    destVC.setRoad(road: road)
    self.navigationController?.pushViewController(destVC, animated: true)
  }
  
}

// MARK: - UITableViewDelegate
extension RoadsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let road = roads[indexPath.row]
    presentScreen(road: road)
  }
}

// MARK: -
extension RoadsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return roads.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let road = roads[indexPath.row]
    cell.textLabel?.text = road.address
    return cell
  }
}

// MARK: - RoadsManagerOutput
extension RoadsViewController: RoadsManagerOutput {
  func didLoadedSensors(sensors: [RoadSensor]) { return }
  
  func didLoadedRoads(roads: [Road]) {
    activityIndicator.stopAnimating()
    self.roads = roads
  }
}
