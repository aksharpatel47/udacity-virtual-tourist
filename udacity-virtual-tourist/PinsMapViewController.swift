//
//  PinsMapViewController.swift
//  udacity-virtual-tourist
//
//  Created by Akshar Patel on 14/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import UIKit
import MapKit

fileprivate let pinIdentifier = "mapPinView"

class PinsMapViewController: UIViewController {

  //MARK: Properties
  let context = DataController.shared.managedObjectContext
  
  //MARK: Outlets
  @IBOutlet weak var pinsMapView: MKMapView!
  
  //MARK: Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let cameraData = UserDefaults.standard.data(forKey: Constants.OfflineKeys.mapCamera),
      let camera = NSKeyedUnarchiver.unarchiveObject(with: cameraData) as? MKMapCamera {
      pinsMapView.setCamera(camera, animated: false)
    }
  }
  
  //MARK: Actions
  @IBAction func dropPinOnMap(_ sender: UILongPressGestureRecognizer) {
    if sender.state == .began {
      let dropPoint = sender.location(in: pinsMapView)
      let dropCoordinate = pinsMapView.convert(dropPoint, toCoordinateFrom: pinsMapView)
      let pin = Pin(coordinate: dropCoordinate, context: context)
      pinsMapView.addAnnotation(pin)
    }
  }
}

//MARK: - MKMapView Delegate
extension PinsMapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
    pinView.animatesDrop = true
    return pinView
  }
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    let cameraData = NSKeyedArchiver.archivedData(withRootObject: mapView.camera)
    UserDefaults.standard.set(cameraData, forKey: Constants.OfflineKeys.mapCamera)
  }
}
