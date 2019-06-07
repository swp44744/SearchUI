//
//  Extensions.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/5/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
  
  func loadImage(from URLString: String, placeHolder: UIImage?) {
    
    self.image = nil
    if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
      self.image = cachedImage
      return
    }
    
    if let url = URL(string: URLString) {
      URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
        if error != nil {
          print("ERROR LOADING IMAGES FROM URL: \(error)")
          DispatchQueue.main.async {
            self.image = placeHolder
          }
          return
        }
        DispatchQueue.main.async {
          if let data = data {
            if let downloadedImage = UIImage(data: data) {
              imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
              self.image = downloadedImage
            }
          }
        }
      }).resume()
    }
  }
}
