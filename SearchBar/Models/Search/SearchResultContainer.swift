//
//  SearchResultContainer.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/4/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import Foundation

struct SearchResultContainer: Decodable {
  let id: String?
  let title: String?
  let link: String?
  let tags: [SearchTags]?
  let views: Int?
  let images: [SearchImages]?
  
  
  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case link
    case tags
    case views
    case images
  }
}
