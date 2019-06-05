//
//  SearchImages.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/4/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import Foundation

struct SearchImages: Decodable {
  let imageId: String?
  let imageTitle: String?
  let imageDescription: String?
  let imageLink: String?
  let imageType: String?
  
  private enum CodingKeys: String, CodingKey {
    case imageId = "id"
    case imageTitle = "title"
    case imageDescription = "description"
    case imageLink = "link"
    case imageType = "type"
  }
  
}
