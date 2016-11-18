//
//  PinsMapViewController.swift
//  udacity-virtual-tourist
//
//  Created by Akshar Patel on 14/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import UIKit
import MapKit
import CoreData

fileprivate let pinIdentifier = "mapPinView"

class PinsMapViewController: UIViewController {

  //MARK: Properties
  let context = DataController.shared.managedObjectContext
  
  //MARK: Outlets
  @IBOutlet weak var pinsMapView: MKMapView!
  
  //MARK: Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set Map Camera to its last persisted position
    if let cameraData = UserDefaults.standard.data(forKey: Constants.OfflineKeys.mapCamera),
      let camera = NSKeyedUnarchiver.unarchiveObject(with: cameraData) as? MKMapCamera {
      pinsMapView.setCamera(camera, animated: false)
    }
    
    // Load existing Pins from Core Data
    
    let fr = NSFetchRequest<Pin>(entityName: "Pin")
    
    if let pins = try? context.fetch(fr) {
      pinsMapView.addAnnotations(pins)
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
  
  //MARK: Navigation Methods
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    if identifier == Constants.Segues.showPinDetail {
      guard let pinDetailVC = segue.destination as? PinDetailViewController,
        let pin = sender as? Pin else {
          return
      }
      
      pinDetailVC.pin = pin
      pinDetailVC.camera = MKMapCamera(lookingAtCenter: pin.coordinate, fromEyeCoordinate: pin.coordinate, eyeAltitude: pinsMapView.camera.altitude)
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
  
  // Open pin detail when a pin is selected
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let pin = view.annotation as? Pin else {
      return
    }
    
    mapView.deselectAnnotation(pin, animated: false)
    
    performSegue(withIdentifier: Constants.Segues.showPinDetail, sender: pin)
  }
  
  // Persist MapView's last seen position
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    let cameraData = NSKeyedArchiver.archivedData(withRootObject: mapView.camera)
    UserDefaults.standard.set(cameraData, forKey: Constants.OfflineKeys.mapCamera)
  }
}
