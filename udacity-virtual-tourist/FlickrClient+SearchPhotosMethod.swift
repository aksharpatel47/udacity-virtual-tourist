//
//  FlickrClient+SearchPhotosMethods.swift
//  udacity-virtual-tourist
//
//  Created by Techniexe on 18/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import Foundation

extension FlickrClient {
  func searchPhotos(for pin: Pin, completionHandler: @escaping (([String]?, Error?) -> Void)) {
    let queryParams: [String:Any] = [
      FConstants.QueryParamKeys.latitude: pin.latitude,
      FConstants.QueryParamKeys.longitude: pin.longitude,
      FConstants.QueryParamKeys.radius: FConstants.QueryParamValues.radius,
      FConstants.QueryParamKeys.page: pageToFetch(for: pin),
      FConstants.QueryParamKeys.extras: FConstants.QueryParamValues.extraURLM
    ]
    
    getRequest(method: FConstants.Methods.searchPhotos, queryParams: queryParams, completionHandler: {
      data, error in
      
      guard let jsonData = data, error == nil else {
        completionHandler(nil, error)
        return
      }
      
      guard let photoDictionary = jsonData[FConstants.ResponseKeys.photosGlobalKey] as? [String:Any],
        let totalPhotos = photoDictionary[FConstants.ResponseKeys.totalPhotos] as? String,
        let totalPhotosCount = Int(totalPhotos),
        let photosArray = photoDictionary[FConstants.ResponseKeys.photosArray] as? [[String:Any]] else {
          let userInfo = [NSLocalizedDescriptionKey: "Error while extracting data from response dictionary"]
          completionHandler(nil, NSError(domain: FConstants.FlickrErrorDomain, code: FConstants.ErrorCodes.missingKeys, userInfo: userInfo))
          return
      }
      
      pin.totalAvailablePhotos = Int32(totalPhotosCount)
      
      
      let urls = photosArray.map({ $0[FConstants.QueryParamValues.extraURLM] as! String })
      completionHandler(urls, nil)
    })
  }
}
