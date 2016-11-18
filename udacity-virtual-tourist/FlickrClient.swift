//
//  FlickrClient.swift
//  udacity-virtual-tourist
//
//  Created by Techniexe on 18/11/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import Foundation

class FlickrClient {
  static let shared = FlickrClient()
  
  func getRequest(method: String, queryParams: [String:Any]?, completionHandler: @escaping (([String:Any]?, Error?) -> Void)) {
    guard let url = createURL(for: method, with: queryParams) else {
      let userInfo = [NSLocalizedDescriptionKey: "Error while creating url for \(method)"]
      completionHandler(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: userInfo))
      return
    }
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: {
      data, response, error in
      
      guard let data = data, error == nil else {
        completionHandler(nil, error)
        return
      }
      
      guard let jsonData = self.deserializeJSON(from: data) as? [String:Any] else {
        let userInfo = [NSLocalizedDescriptionKey: "Error while converting data to json dictionary in \(method)"]
        completionHandler(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: userInfo))
        return
      }
      
      completionHandler(jsonData, nil)
    })
    
    task.resume()
  }
}
