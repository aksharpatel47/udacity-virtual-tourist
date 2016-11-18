//
//  PhotoAlbumViewController.swift
//  udacity-virtual-tourist
//
//  Created by Akshar Patel on 15/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {
  
  //MARK: Properties
  var pin: Pin!
  var camera: MKMapCamera!
  var blockOperations = [BlockOperation]()
  var fetchResultsController: NSFetchedResultsController<Photo>? {
    didSet {
      fetchResultsController?.delegate = self
      executeSearch()
      photoCollectionView.reloadData()
    }
  }
  
  //MARK: Outlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var photoCollectionView: UICollectionView!
  
  //MARK: Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.setCamera(camera, animated: false)
    mapView.addAnnotation(pin)
    
    let fr = NSFetchRequest<Photo>(entityName: "Photo")
    fr.sortDescriptors = [NSSortDescriptor(key: "urlPath", ascending: true)]
    fr.predicate = NSPredicate(format: "pin = %@", pin)
    
    fetchResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: DataController.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
  }
  
  //MARK: Actions
  @IBAction func getPhotos(_ sender: Any) {
    title = "Getting New Photos..."
    FlickrClient.shared.searchPhotos(for: pin, completionHandler: {
      urlPaths, error in
      
      guard let urlPaths = urlPaths, error == nil else {
        return
      }
      
      DispatchQueue.main.async {
        self.title = nil
      }
      
      DataController.shared.addPhotos(from: urlPaths, belongingTo: self.pin)
    })
  }
}

//MARK: - NSFetchResultsController Execute Search
extension PhotoAlbumViewController {
  func executeSearch() {
    guard let fc = fetchResultsController else {
      return
    }
    
    do {
      try fc.performFetch()
    } catch {
      print("Error while trying to get photos of a particular pin. \(error)")
      return
    }
    
    if let objects = fc.sections?.first?.numberOfObjects, objects == 0 {
      getPhotos(self)
    }
  }
}

//MARK: - Collection View Delegate
extension PhotoAlbumViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
}

//MARK: - Collection View Datasource
extension PhotoAlbumViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let fc = fetchResultsController,
      let count = fc.sections?.first?.numberOfObjects else {
      return 0
    }
    
    return count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let photo = fetchResultsController?.object(at: indexPath)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
    
    if let photoData = photo?.data as? Data {
      cell.imageView.image = UIImage(data: photoData)
      cell.activityIndicator.stopAnimating()
    } else {
      cell.imageView.image = nil
      cell.activityIndicator.startAnimating()
      photo?.downloadData()
    }
    
    return cell
  }
}

//MARK: - NSFetchResultsController Delegate
extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      blockOperations.append(BlockOperation {
        self.photoCollectionView.insertItems(at: [newIndexPath!])
      })
    case .update:
      blockOperations.append(BlockOperation {
        self.photoCollectionView.reloadItems(at: [indexPath!])
      })
    case .delete:
      blockOperations.append(BlockOperation {
        self.photoCollectionView.deleteItems(at: [indexPath!])
      })
    default:
      break
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    photoCollectionView.performBatchUpdates({
      for operation in self.blockOperations {
        operation.start()
      }
    }) { finished in
      self.blockOperations.removeAll()
    }
  }
}
