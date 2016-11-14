//
//  PhotoAlbumViewController.swift
//  udacity-virtual-tourist
//
//  Created by Akshar Patel on 15/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var photoCollectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension PhotoAlbumViewController: UICollectionViewDelegate {
  
}

extension PhotoAlbumViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return UICollectionViewCell()
  }
}
