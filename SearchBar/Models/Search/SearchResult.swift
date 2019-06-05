//
//  SearchResult.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/4/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
  let data: [SearchResultContainer]?
  


private enum CodingKeys: String, CodingKey {
  case data = "data"

}

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.data = try container.decode([SearchResultContainer].self, forKey: .data)
    
  }

}
