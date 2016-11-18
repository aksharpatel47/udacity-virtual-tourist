//
//  Photo+Extension.swift
//  udacity-virtual-tourist
//
//  Created by Techniexe on 18/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import Foundation
import CoreData

fileprivate let photoEntity = "Photo"

extension Photo {
  convenience init(urlPath: String, context: NSManagedObjectContext) {
    if let entity = NSEntityDescription.entity(forEntityName: photoEntity, in: context) {
      self.init(entity: entity, insertInto: context)
      self.urlPath = urlPath
    } else {
      fatalError("Error while creating Photo Entity")
    }
  }
  
  func downloadData() {
    DataController.shared.performBackgroundBatchOperation {
      backgroundContext in
      
      guard let urlPath = self.urlPath,
        let url = URL(string: urlPath) else {
        return
      }
      
      self.data = try? Data(contentsOf: url) as NSData
      
    }
  }
}
