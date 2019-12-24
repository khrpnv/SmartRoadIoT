//
//  MenuViewController.swift
//  SmartRoadIoT
//
//  Created by Illia Khrypunov on 12/24/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func presentScreen(with id: String) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let destVC: UIViewController
    if #available(iOS 13.0, *) {
      destVC = storyboard.instantiateViewController(identifier: id)
    } else {
      destVC = storyboard.instantiateViewController(withIdentifier: id)
    }
    destVC.modalPresentationStyle = .fullScreen
    self.navigationController?.pushViewController(destVC, animated: true)
  }
  
  @IBAction func sensorsPressed(_ sender: Any) {
    presentScreen(with: "ServiceStationsViewController")
  }
  
  @IBAction func roadSensorsPressed(_ sender: Any) {
    presentScreen(with: "RoadsViewController")
  }
}
