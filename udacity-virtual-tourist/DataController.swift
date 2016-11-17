//
//  DataController.swift
//  udacity-virtual-tourist
//
//  Created by Akshar Patel on 18/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import Foundation
import CoreData

class DataController {
  
  static let shared = DataController()
  
  var persistentStoreCoordinate: NSPersistentStoreCoordinator
  var managedObjectContext: NSManagedObjectContext
  var storeURL: URL
  
  init() {
    guard let url = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
      fatalError("Error while finding Data Model file")
    }
    
    storeURL = url
    
    guard let mom = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Error while creating a Managed Object Model from Data Model")
    }
    
    persistentStoreCoordinate = NSPersistentStoreCoordinator(managedObjectModel: mom)
    managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinate
    
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentURL = urls[urls.count - 1]
    let sqliteURL = documentURL.appendingPathComponent("DataModel.sqlite")
    
    do {
      try persistentStoreCoordinate.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteURL, options: nil)
    } catch {
      fatalError("Error while adding sqlite store to the persistent store coordinator. \(error)")
    }
  }
}
