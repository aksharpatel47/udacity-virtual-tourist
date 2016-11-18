//
//  FlickrClient+Convenience.swift
//  udacity-virtual-tourist
//
//  Created by Techniexe on 18/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import Foundation

extension FlickrClient {
  func pageToFetch(for pin: Pin) -> Int {
    if pin.totalAvailablePhotos == 0 {
      return 1
    }
    
    let totalPages = Int(pin.totalAvailablePhotos) / FConstants.QueryParamValues.perPage
    return min(Int(arc4random_uniform(UInt32(totalPages))), Int(arc4random_uniform(UInt32(FConstants.maxPages))))
  }
  
  func createURL(for method: String, with queryParameters: [String:Any]?) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = FConstants.URLComponents.scheme
    urlComponents.host = FConstants.URLComponents.host
    urlComponents.path = FConstants.URLComponents.path
    urlComponents.queryItems = [
      URLQueryItem(name: FConstants.QueryParamKeys.method, value: method),
      URLQueryItem(name: FConstants.QueryParamKeys.apiKey, value: FConstants.QueryParamValues.apiKey),
      URLQueryItem(name: FConstants.QueryParamKeys.format, value: FConstants.QueryParamValues.jsonFormat),
      URLQueryItem(name: FConstants.QueryParamKeys.noJSONCallback, value: "\(FConstants.QueryParamValues.noJSONCallback)"),
      URLQueryItem(name: FConstants.QueryParamKeys.perPage, value: "\(FConstants.QueryParamValues.perPage)")
    ]
    
    guard let queryParameters = queryParameters else {
      return urlComponents.url
    }
    
    for (key, value) in queryParameters {
      urlComponents.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
    }
    
    return urlComponents.url
  }
  
  func deserializeJSON(from data: Data) -> Any? {
    return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
  }
}
