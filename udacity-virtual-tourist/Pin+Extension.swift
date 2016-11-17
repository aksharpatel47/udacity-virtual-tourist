//
//  Pin+Extension.swift
//  udacity-virtual-tourist
//
//  Created by Akshar Patel on 18/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension Pin: MKAnnotation {
  public var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  convenience init(coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext) {
    if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
      self.init(entity: entity, insertInto: context)
      latitude = coordinate.latitude
      longitude = coordinate.longitude
    } else {
      fatalError("Error while creating a managed object of Pin with coordinate \(coordinate)")
    }
  }
}
