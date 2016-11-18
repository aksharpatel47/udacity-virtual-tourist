//
//  FlickrClient+Convenience.swift
//  udacity-virtual-tourist
//
//  Created by Techniexe on 18/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import Foundation

extension FlickrClient {
  struct FConstants {
    
    static let maxPages = 200
    static let FlickrErrorDomain = "FlickrErrorDomain"
    
    struct ErrorCodes {
      static let missingKeys = 1
    }
    
    struct URLComponents {
      static let host = "api.flickr.com"
      static let scheme = "https"
      static let path = "/services/rest"
    }
    
    struct Methods {
      static let searchPhotos = "flickr.photos.search"
    }
    
    struct QueryParamKeys {
      static let method = "method"
      static let apiKey = "api_key"
      static let latitude = "lat"
      static let longitude = "lon"
      static let radius = "radius"
      static let extras = "extras"
      static let format = "format"
      static let noJSONCallback = "nojsoncallback"
      static let perPage = "per_page"
      static let page = "page"
    }
    
    struct QueryParamValues {
      static let apiKey = "4d6dc2d62db778dbbef818f4a819c841"
      static let radius = 5
      static let extraURLM = "url_m"
      static let jsonFormat = "json"
      static let noJSONCallback = 1
      static let perPage = 20
    }
    
    struct ResponseKeys {
      static let photosGlobalKey = "photos"
      static let totalPhotos = "total"
      static let photosArray = "photo"
    }
  }
}
