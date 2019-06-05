//
//  SessionResult.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/4/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import Foundation

enum SessionResult<T, E> {
  case success(T)
  case failure(E)
}
