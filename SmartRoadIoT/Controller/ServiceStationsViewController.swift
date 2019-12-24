//
//  ServiceStationsViewController.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

class ServiceStationsViewController: UIViewController {
  
  private let cellId: String = "serviceCell"
  private var services: [String : [ServiceStation]] = [:] {
    didSet {
      types = Array(services.keys).sorted()
      tableView.reloadData()
    }
  }
  private var types: [String] = []
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Services"
    setupTableView()
    activityIndicator.startAnimating()
    let serviceManager = ServiceManager(delegate: self)
    serviceManager.getAllStations()
  }
}

// MARK: - Private
private extension ServiceStationsViewController {
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func presentScreen(station: ServiceStation) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let destVC: SensorsViewController
    if #available(iOS 13.0, *) {
      destVC = storyboard.instantiateViewController(identifier: "SensorsViewController")
    } else {
      destVC = storyboard.instantiateViewController(withIdentifier: "SensorsViewController") as! SensorsViewController
    }
    destVC.modalPresentationStyle = .fullScreen
    destVC.setStation(station: station)
    self.navigationController?.pushViewController(destVC, animated: true)
  }
}

// MARK: - UITableViewDelegate
extension ServiceStationsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let type = types[indexPath.section]
    guard let service = services[type]?[indexPath.row] else { return }
    presentScreen(station: service)
  }
}

// MARK: - UITableViewDataSource
extension ServiceStationsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return types.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return services[types[section]]?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return types[section]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ServiceTableViewCell else {
      fatalError()
    }
    let type = types[indexPath.section]
    if let service = services[type]?[indexPath.row] {
      cell.configureCell(with: service.name)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

// MARK: - ServiceManagerOutput
extension ServiceStationsViewController: ServiceManagerOutput {
  func didLoadedSensors(sensors: [Sensor]) { return }
  
  func didLoadedAllServiceStations(services: [String : [ServiceStation]]) {
    activityIndicator.stopAnimating()
    self.services = services
  }
}
