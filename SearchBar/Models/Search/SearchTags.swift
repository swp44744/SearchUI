//
//  SearchTags.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/4/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import Foundation

struct SearchTags: Decodable {
  
  let name: String?
  let displayName: String?
  let totalItems: String?
}


private enum CodingKeys: String, CodingKey {
  case name
  case displayName
  case totalItems = "total_items"
}
