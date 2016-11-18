//
//  DataController+Photo.swift
//  udacity-virtual-tourist
//
//  Created by Techniexe on 18/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import Foundation

extension DataController {
  func addPhotos(from urlPaths: [String], belongingTo pin: Pin) {
    
    let pinObjectID = pin.objectID
    
    performBackgroundBatchOperation {
      backgroundContext in
      
      guard let pinInBGContext = backgroundContext.object(with: pinObjectID) as? Pin else {
        return
      }
      
      for urlPath in urlPaths {
        let photo = Photo(urlPath: urlPath, context: backgroundContext)
        photo.pin = pinInBGContext
      }
    }
  }
}
