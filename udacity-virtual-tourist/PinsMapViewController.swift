//
//  PinsMapViewController.swift
//  udacity-virtual-tourist
//
//  Created by Akshar Patel on 14/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import UIKit
import MapKit

class PinsMapViewController: UIViewController {

  //MARK: Outlets
  @IBOutlet weak var pinsMapView: MKMapView!
  
  //MARK: Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //MARK: Actions
  @IBAction func longPressedAction(_ sender: UILongPressGestureRecognizer) {
    if sender.state == .began {
      print("Long Pressed")
    }
  }
}

//MARK: - MKMapView Delegate
extension PinsMapViewController: MKMapViewDelegate {
  
}
